#' geocode
#'
#' Geocode an address or postcode with Google Geocode API
#' Require an API key which can be obtained from:
#' https://developers.google.com/maps/documentation/geocoding/get-api-key
#'
#' Geocoding converts an address or postcode to latitude/longitude coordinates
#'
#' Address should not contain special characters like spaces (which should be
#' replaced with '+'). See https://developers.google.com/maps/documentation/geocoding/web-service-best-practices#BuildingURLs
#'
#' @param address A human-readable address or postcode. Should not contain
#' special characters like spaces.
#' @param key Either a character string containing your API key or the location
#' of a .txt file containing the string on the first line only
#' @param output_format json or xml (currently only json is supported and is
#' the default)
#'
#' @return A data frame with two columns, lat and long
#' @export
#'
geocode <- function(address, key, output_format = "json") {
  if (length(address) > 2500) {
    warning("length of address is greater than the free query limit")
  }

  if (!requireNamespace("jsonlite")) {
    stop("jsonlite package required.\n
          Install with install.packages('jsonlite')")
  }

  if (grepl(".txt", key)) {
    key = readLines(key)
  }
  if (!class(key) == "character") {
    stop("key is not a string or key .txt file does not contain a string.")
  }

  if (output_format != "json") {
    stop("Only JSON is supported at the moment, sorry")
  }

  if (any(grepl(" ", address))) {
    stop("One or more addresses contains spaces. Please replace with '+'")
  }

  # Create output; don't grow with for() loops!
  long = vector("double", length(address))
  lat  = vector("double", length(address))
  bad_results = vector("integer", length(address))

  for (i in seq_along(address)) {
    # Construct Google Geocode API URL
    # Takes the form of:
    # https://maps.googleapis.com/maps/api/geocode/outputFormat?parameters
    url <- paste0("https://maps.googleapis.com/maps/api/geocode/",
                  output_format, "?",
                  "address=", address[i],
                  "&key=", key)

    result <- jsonlite::fromJSON(url)

    status <- result[["status"]]
    if (status == "OVER_QUERY_LIMIT")
    {
      stop("Over query limit. Stopping.")
    }
    else if (status == "REQUEST_DENIED")
    {
      stop("Request denied. Stopping")
    }
    else if (status == "ZERO_RESULTS")
    {
      warning("A request returned with zero results.")
      bad_results[i] = TRUE
    }
    else if (status == "INVALID_REQUEST")
    {
      warning("A request was invalid.")
      bad_results[i] = TRUE
    }
    else if (status == "UNKNOWN_stop")
    {
      warning("Server returned unknown stop")
      bad_results[i] = TRUE
    }
    else if (status == "OK")
    {
      long[i] <- result[[1]][["geometry"]][["location"]][["lng"]][1]
      lat[i]  <- result[[1]][["geometry"]][["location"]][["lat"]][1]
      bad_results[i] <- FALSE
    }

    if (sum(bad_results) > 5) {
      stop("5 bad results in a row.")
    }

    Sys.sleep(0.05)  # Less than 50 queries per second

  }

  coords <- data.frame(
    long, lat
  )

  coords
}
