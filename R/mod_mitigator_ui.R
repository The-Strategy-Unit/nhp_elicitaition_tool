#' mitigator UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
mod_mitigator_ui <- function(id) {
  ns <- shiny::NS(id)

  previous_button <- shinyjs::disabled(
    shiny::actionButton(ns("prev_strat"), "Previous")
  )

  next_button <-
    identity(
      shiny::actionButton(ns("next_strat"), "Next")
    )

  complete_button <-
    shinyjs::hidden(
      shiny::actionButton(
        ns("complete"),
        "Complete"
      )
    )

  bslib::layout_columns(
    col_widths = c(8, 4, 12, 6, 6, 12),
    bslib::card(
      bslib::card_title(shiny::textOutput(ns("strategy"))),
      shiny::uiOutput(ns("mitigator_text"))
    ),
    bslib::card(
      bslib::card_header("Navigation"),
      bslib::layout_columns(previous_button, next_button, col_widths = c(6, 6)),
      complete_button,
      shinyWidgets::progressBar(
        ns("progress"),
        0,
        display_pct = TRUE
      )
    ),
    bslib::card(
      bslib::card_header("Your prediction"),
      bslib::card_body(
        shiny::sliderInput(ns("param_values"),
          "Annual growth rate",
          min = get_golem_config("range")$low,
          max = get_golem_config("range")$high,
          value = c(get_golem_config("range")$low, get_golem_config("range")$high),
          step = 0.01,
          width = "100%"
        )
      )
    ),
    bslib::card(
      shiny::textAreaInput(
        ns("why_lo"),
        label = "What is your rationale for your surprisingly low prediction (P10) of residual growth?",
        width = "100%"
      )
    ),
    bslib::card(
      shiny::textAreaInput(
        ns("why_hi"),
        label = "What is your rationale for your surprisingly high prediction (P90) of residual growth?",
        width = "100%"
      )
    ),
    if (!is_phase_1()) {
      bslib::card(
        shinycssloaders::withSpinner(
          plotly::plotlyOutput(ns("results_plot"), height = "400px")
        )
      )
    }
  )
}
