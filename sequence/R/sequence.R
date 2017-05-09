#' sequence - a HTML widget for sequence sunburst chart
#'
#' @import htmlwidgets
#' @import colorspace
#' @import stringi
#' 
#' @param df data frame intended to be used to plot in a sequence sunburst chart
#' @param split_on character; column names of the categorical variables to be splitted on
#' @param parse logical; whether or not the data frame need to be parsed into hierachial df
#' @param width integer; width of the widget
#' @param height integer; height of the widget
#' @param elementId character; id assigned to the resulting widget
#'
#' @export
sequence <- function(df, split_on, parse = TRUE, width = NULL, height = NULL, elementId = NULL) {
   
   if (class(df) != "data.frame") {
      stop("sunburst doesn't know how to handle non data frame object")
   }
   
   if (length(split_on) == 0) {
      stop("sunburst doesn't know how to handle zero-length split on variables")
   }
   
   if (!(all(split_on %in% colnames(df)))) {
      stop("data frame does not contain columns intending to plot")
   }
   
   if (!check_character(df, split_on)) {
      warning("sunburst encounters non-categorical variable; make sure this is intended")
   }
   
   # parse into hierachial
   hierachial_df <- parse_hierachial_df(df, split_on)
   
   # obtain unique values in category and strip white spaces
   keys <- unique(as.vector(as.matrix(df[, split_on])))
   keys <- sapply(keys, function(d) { gsub("[-, ]", "", d) })
   
   # obtain unique color for every key
   colors <- colorspace::rainbow_hcl(length(keys))
   colormap <- data.frame(keys, colors)

  # forward options using x
  x = list(
    data = hierachial_df,
    colormap = colormap
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'sequence',
    x,
    width = width,
    height = height,
    package = 'sequence',
    elementId = elementId
  )
}

# recursive function that parses a given data frame into hierachial structure
# df requirement is specified here: https://bl.ocks.org/kerryrodden/7090426
parse_hierachial_df <- function(df, split_on, head = "") {
   
   if (length(split_on) == 0) {
      return(paste0(head, "-end,1\n"))
   }
   
   #initialize an empty string to contain all aggregated list
   aggregate_df <- ""
   
   # find out which variable to split on
   thisVar <- split_on[1]
   
   # split the dataset into layers
   split_df <- split(df, df[, thisVar])
   layers <- names(split_df)


   # iterate through the layers and count frequency
   for (i in 1:length(layers)) {
      
      # obtain this layer
      this_sublist <- split_df[[layers[i]]]
      
      # re-define head: remove white space and dashes
      this_layer_name <- gsub("[-, ]", "", layers[i])
      if (head == "") {
         this_head <- this_layer_name
      } else {
         this_head <- paste0(head, "-", gsub("-", "", this_layer_name))
      }
      
      # create fomatted string of this row
      this_row <- paste0(paste0(this_head,"-end"), ",", as.character(nrow(this_sublist)), "\n")
      
      # create csv for rest of the child
      sub_df <- parse_hierachial_df(this_sublist, split_on[-1], head = this_head)
      aggregate_df <- paste0(aggregate_df, this_row, sub_df)
   }
   
   return(aggregate_df)
}


#
# check_character checks if a data frame contains the columns it intends to split on
#
check_character <- function(df, split_on) {
   for (i in 1:length(split_on)) {
      if (!(class(df[, split_on[i]]) %in% c("character", "factor"))) {
         return(FALSE)
      }
   }
   return(TRUE)
}

#' Shiny bindings for sequence
#'
#' Output and render functions for using sequence within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a sequence
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name sequence-shiny
#'
#' @export
sequenceOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'sequence', width, height, package = 'sequence')
}

#' @rdname sequence-shiny
#' @export
renderSequence <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, sequenceOutput, env, quoted = TRUE)
}
