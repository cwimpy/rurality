#' Specification Curve Analysis Across Rurality Classification Schemes
#'
#' Runs a specification curve across four rurality classification schemes
#' (RUCC, RUCA, NCHS, OMB), two functional forms (ordinal and binary
#' metro/nonmetro), and three covariate sets, for one or more user-supplied
#' county-level outcome variables. Returns a tidy data frame of coefficient
#' estimates suitable for plotting or further analysis.
#'
#' @param data A data frame containing a 5-digit county FIPS column and at
#'   least one numeric outcome variable.
#' @param outcome A character vector naming one or more outcome columns in
#'   `data`.
#' @param fips_col Name of the FIPS column in `data`. Default `"fips"`.
#' @param covariates Optional character vector of additional covariate column
#'   names already present in `data`. These are added on top of the three
#'   built-in covariate sets (see Details). Default `NULL`.
#' @param schemes Character vector of schemes to include. Any subset of
#'   `c("rucc", "ruca", "nchs", "omb")`. Default: all four.
#' @param forms Character vector of functional forms. Any subset of
#'   `c("ordinal", "binary")`. Default: both.
#' @param covar_sets Character vector of built-in covariate sets to use.
#'   Any subset of `c("minimal", "full", "state_fe")`. Default: all three.
#'   See Details.
#' @param plot Logical. If `TRUE` (default), print a specification curve
#'   plot. Requires \pkg{ggplot2}.
#'
#' @return A tibble with one row per specification per outcome, containing:
#'   \describe{
#'     \item{outcome}{Outcome variable name}
#'     \item{scheme}{Rurality scheme (`rucc`, `ruca`, `nchs`, `omb`)}
#'     \item{form}{Functional form (`ordinal` or `binary`)}
#'     \item{covars}{Covariate set label}
#'     \item{n}{Number of observations}
#'     \item{estimate}{Coefficient on the rurality predictor}
#'     \item{std.error}{Standard error}
#'     \item{statistic}{t-statistic}
#'     \item{p.value}{p-value}
#'     \item{conf.low}{Lower 95% confidence interval}
#'     \item{conf.high}{Upper 95% confidence interval}
#'     \item{r.squared}{Model R-squared}
#'   }
#'
#' @details
#' `rurality_spec()` joins the package's `county_crosswalk` dataset (FIPS
#' backbone with RUCC, RUCA, NCHS, OMB, and ACS covariates) onto `data` by
#' FIPS code, then fits OLS models for every combination of scheme, form,
#' and covariate set requested.
#'
#' **Built-in covariate sets** (using ACS 2022 variables from the crosswalk):
#' \itemize{
#'   \item `"minimal"`: log(population) + log(median income)
#'   \item `"full"`: minimal + percent BA or higher + percent non-Hispanic white
#'   \item `"state_fe"`: full + state fixed effects (`factor(state_fips)`)
#' }
#'
#' **Ordinal predictors** are standardized (mean 0, SD 1) so that
#' coefficients are comparable across schemes with different scale lengths
#' (RUCC: 1-9, RUCA: 1-10, NCHS: 1-6, OMB: 1-3).
#'
#' **Binary predictors** code metropolitan = 0, nonmetropolitan = 1, using
#' standard cutpoints: RUCC >= 4, RUCA >= 4, NCHS >= 5, OMB != "metro".
#'
#' Any user-supplied `covariates` are appended to all three built-in covariate
#' sets.
#'
#' @examples
#' \dontrun{
#' # Minimal example with a built-in outcome proxy
#' library(dplyr)
#'
#' # Attach a synthetic outcome to the crosswalk
#' df <- county_rurality |>
#'   select(fips) |>
#'   mutate(y = rnorm(n()))
#'
#' results <- rurality_spec(df, outcome = "y")
#' print(results)
#' }
#'
#' @export
rurality_spec <- function(
    data,
    outcome,
    fips_col    = "fips",
    covariates  = NULL,
    schemes     = c("rucc", "ruca", "nchs", "omb"),
    forms       = c("ordinal", "binary"),
    covar_sets  = c("minimal", "full", "state_fe"),
    plot        = TRUE
) {

  # ── Input validation ────────────────────────────────────────────────────────
  schemes    <- match.arg(schemes,    c("rucc", "ruca", "nchs", "omb"),
                          several.ok = TRUE)
  forms      <- match.arg(forms,      c("ordinal", "binary"),
                          several.ok = TRUE)
  covar_sets <- match.arg(covar_sets, c("minimal", "full", "state_fe"),
                          several.ok = TRUE)

  if (!fips_col %in% names(data)) {
    rlang::abort(paste0("Column '", fips_col, "' not found in `data`."))
  }
  missing_outcomes <- setdiff(outcome, names(data))
  if (length(missing_outcomes)) {
    rlang::abort(paste0("Outcome column(s) not found in `data`: ",
                        paste(missing_outcomes, collapse = ", ")))
  }

  # ── Join crosswalk ──────────────────────────────────────────────────────────
  xwalk <- tryCatch(
    get("county_crosswalk", envir = asNamespace("rurality")),
    error = function(e) NULL
  )
  if (is.null(xwalk)) {
    e <- new.env()
    utils::data("county_crosswalk", package = "rurality", envir = e)
    xwalk <- e$county_crosswalk
  }
  if (is.null(xwalk)) {
    rlang::abort(paste0(
      "`county_crosswalk` not found in the rurality package. ",
      "Install the development version: remotes::install_github('cwimpy/rurality')"
    ))
  }

  data[[fips_col]] <- stringr::str_pad(as.character(data[[fips_col]]),
                                       5, pad = "0")
  df <- dplyr::left_join(data, xwalk, by = stats::setNames("fips", fips_col))

  # ── Derive scheme variables ─────────────────────────────────────────────────
  df <- df |>
    dplyr::mutate(
      omb_3cat = dplyr::case_when(
        .data$omb_class == "metro"   ~ 1L,
        .data$omb_class == "micro"   ~ 2L,
        .data$omb_class == "noncore" ~ 3L
      ),
      # Ordinal (standardized)
      rucc_ord = as.numeric(scale(.data$rucc_2023)),
      ruca_ord = as.numeric(scale(.data$ruca_2020_county)),
      nchs_ord = as.numeric(scale(.data$nchs_2023)),
      omb_ord  = as.numeric(scale(.data$omb_3cat)),
      # Binary: metro = 0, nonmetro = 1
      rucc_bin = as.integer(.data$rucc_2023 >= 4),
      ruca_bin = as.integer(.data$ruca_2020_county >= 4),
      nchs_bin = as.integer(.data$nchs_2023 >= 5),
      omb_bin  = as.integer(.data$omb_class != "metro"),
      # Built-in covariates
      log_pop = log(.data$pop_total),
      log_inc = log(.data$median_inc)
    )

  # ── Covariate string builder ────────────────────────────────────────────────
  user_covs <- if (!is.null(covariates)) paste("+", covariates) else ""

  covar_map <- list(
    minimal  = paste("log_pop + log_inc", user_covs),
    full     = paste("log_pop + log_inc + pct_ba_plus + pct_nh_white",
                     user_covs),
    state_fe = paste("log_pop + log_inc + pct_ba_plus + pct_nh_white",
                     "+ factor(state_fips)", user_covs)
  )

  # ── Build specification grid ────────────────────────────────────────────────
  grid <- expand.grid(
    outcome    = outcome,
    scheme     = schemes,
    form       = forms,
    covars     = covar_sets,
    stringsAsFactors = FALSE
  )

  # ── Fit models ──────────────────────────────────────────────────────────────
  fit_one <- function(outcome_var, scheme, form, covars) {
    predictor <- paste0(scheme, "_", substr(form, 1, 3))  # e.g. rucc_ord
    covar_str <- covar_map[[covars]]
    formula_str <- paste(outcome_var, "~", predictor, "+", covar_str)

    d <- df[is.finite(df[[outcome_var]]) &
              !is.na(df[[predictor]]) &
              !is.na(df$log_pop) &
              !is.na(df$log_inc), ]

    tryCatch({
      fit <- stats::lm(stats::as.formula(formula_str), data = d)
      coef_row <- broom_tidy(fit, predictor)
      coef_row$n       <- stats::nobs(fit)
      coef_row$r.squared <- summary(fit)$r.squared
      coef_row
    }, error = function(e) NULL)
  }

  results <- Map(
    fit_one,
    grid$outcome, grid$scheme, grid$form, grid$covars
  )

  out <- dplyr::bind_rows(
    lapply(seq_along(results), function(i) {
      r <- results[[i]]
      if (is.null(r)) return(NULL)
      dplyr::bind_cols(grid[i, , drop = FALSE], r)
    })
  )

  # ── Plot ─────────────────────────────────────────────────────────────────────
  if (plot && nrow(out) > 0) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      message("Install ggplot2 to produce the specification curve plot.")
    } else {
      print(spec_curve_plot(out))
    }
  }

  out
}

# ── Internal helpers ──────────────────────────────────────────────────────────

# Minimal broom::tidy()-like extractor without taking broom as a dependency
broom_tidy <- function(fit, term) {
  cf  <- summary(fit)$coefficients
  idx <- match(term, rownames(cf))
  if (is.na(idx)) {
    return(data.frame(estimate = NA_real_, std.error = NA_real_,
                      statistic = NA_real_, p.value = NA_real_,
                      conf.low = NA_real_, conf.high = NA_real_))
  }
  ci <- tryCatch(stats::confint(fit, parm = term, level = 0.95),
                 error = function(e) matrix(c(NA, NA), nrow = 1))
  data.frame(
    estimate  = cf[idx, 1],
    std.error = cf[idx, 2],
    statistic = cf[idx, 3],
    p.value   = cf[idx, 4],
    conf.low  = ci[1, 1],
    conf.high = ci[1, 2]
  )
}

spec_curve_plot <- function(results) {
  scheme_labels <- c(rucc = "RUCC", ruca = "RUCA", nchs = "NCHS", omb = "OMB")

  d <- results |>
    dplyr::filter(!is.na(.data$estimate)) |>
    dplyr::mutate(
      significant  = .data$p.value < 0.05,
      scheme_label = scheme_labels[.data$scheme],
      rank         = rank(.data$estimate, ties.method = "first")
    )

  ggplot2::ggplot(d, ggplot2::aes(
    x = .data$rank, y = .data$estimate,
    color = .data$significant
  )) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed",
                        color = "grey60", linewidth = 0.4) +
    ggplot2::geom_linerange(
      ggplot2::aes(ymin = .data$conf.low, ymax = .data$conf.high),
      alpha = 0.35, linewidth = 0.5
    ) +
    ggplot2::geom_point(size = 1.8) +
    ggplot2::scale_color_manual(
      values = c(`FALSE` = "grey65", `TRUE` = "#2166AC"),
      guide  = "none"
    ) +
    ggplot2::scale_x_continuous(breaks = NULL) +
    ggplot2::facet_wrap(~ .data$outcome, scales = "free_y") +
    ggplot2::labs(
      x     = paste0("Specifications (n = ", nrow(d), "), ordered by estimate"),
      y     = "Coefficient on rurality predictor",
      title = "Specification Curve: Rurality Classification Schemes"
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold")
    )
}
