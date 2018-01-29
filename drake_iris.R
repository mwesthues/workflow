library("drake")
data("iris")

species <- as.character(unique(iris[, "Species"]))

split_by_species <- function(dat, species_var, species_lvl) {
  dat[dat[, species_var] == species_lvl, ]
}

species_plan <- drake::drake_plan(
  data = split_by_species(
    species_var = "Species",
    species_lvl = "SPECIES"
  ),
  # Make sure to use double quotes instead of single quotes.
  # That way, drake knows that "Species" and "SPECIES"
  # are ordinary strings, not the names of file dependencies.
  strings_in_dots = "literals"
)

species_plan

##   target                                                            command
## 1   data split_by_species(species_var = "Species", species_lvl = "SPECIES")

# Here, SPECIES is a wildcard.
# Drake does not care that it appears in quotes.
# It will evaluate the wildcard anyway.
new_plan <- evaluate_plan(
  plan = species_plan,
  wildcard = "SPECIES",
  values = species
)

new_plan
