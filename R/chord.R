#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
chord <- function(mat, color_map, width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    color_map = color_map,
    mat = mat
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'chord',
    x,
    width = width,
    height = height,
    package = 'chord',
    elementId = elementId
  )
}

#' Shiny bindings for chord
#'
#' Output and render functions for using chord within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a chord
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name chord-shiny
#'
#' @export
chordOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'chord', width, height, package = 'chord')
}

#' @rdname chord-shiny
#' @export
renderChord <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, chordOutput, env, quoted = TRUE)
}
