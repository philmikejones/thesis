# Doncaster population cartogram ====
if (!file.exists("figures/cache/don_pop_cart.pdf")) {
  pop_cart <- cartogram::cartogram(don_comm, "pop_16_plus")

  pop_cart <- tm_shape(pop_cart) +
    tm_polygons(col = "pop_16_plus", title = "Population aged 16 and over") +
    tm_shape(pop_cart[pop_cart@data$pop_16_plus > 5000, ]) +
    tm_text(text = "comm_name", size = "pop_16_plus", legend.size.show = FALSE) +
    tm_layout(frame = FALSE)

  tmap::save_tmap(pop_cart, "figures/cache/don_pop_cart.pdf",
                  width = 210, units = "mm")

}


# Systematic review flowchart ====
if (!file.exists("figures/cache/flowchart.pdf")) {
  system2("latexmk", c("-pdf", "-jobname=inst/systematic_review/flowchart",
                       "inst/systematic_review/flowchart.tex"))
  system2("mv", c("inst/systematic_review/flowchart.pdf", "figures/cache/"))

  fc_files <- list.files("inst/systematic_review", "flowchart",
                         full.names = TRUE)
  fc_files <- fc_files[fc_files != "inst/systematic_review/flowchart.tex"]
  lapply(fc_files, file.remove)
  rm(fc_files)
}


# n Kids in poverty cartogram ====
if (!file.exists("figures/cache/kid_pov_cart.pdf")) {
  kid_pov_cart <- cartogram::cartogram(don_oa, "kids_pov", maxSizeError = 5)

  kid_pov_cart <- tmap::tm_shape(kid_pov_cart) +
    tm_polygons(col = "kids_pov",
                title = "Cartogram of number of children in poverty") +
    tm_layout(frame = FALSE)

  save_tmap(kid_pov_cart, filename = "figures/cache/kid_pov_cart.pdf",
            width = 210, units = "mm")
}
