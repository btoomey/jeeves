#' Run all tests in the Supporting_Macros/tests folder
#'
#'
#'
#' @param pluginDir plugin directory
#' @param build_doc whether or not to build the README file.
#' @export
runTests <- function(pluginDir = ".", build_doc = TRUE){
  dirs <- dirNames()
  with_dir_(file.path(pluginDir, dirs$extras, 'Tests'), {
    tests <- list.files(".",  pattern = '.yxmd')
    results <- lapply(seq_along(tests), function(i){
      message("Testing ", tools::file_path_sans_ext(basename(tests[i])))
      runWorkflow(tests[i])
    })
    names(results) <- basename(tests)
    y <- lapply(results, function(x){
      ifelse(is.null(attr(x, 'status')), 0, attr(x, 'status'))
    })
    x <- jsonlite::toJSON(y, auto_unbox = TRUE)
    cat(x, file = '_tests.json')
    res2 <- lapply(results, function(x){x[-1]})
    cat(jsonlite::toJSON(res2, auto_unbox = TRUE), file = '_results.json')
    if (build_doc) {
      rmarkdown::render('README.Rmd')
      browseURL('README.html')
    }
  })
}

#' @export
runTests2 <- function(pluginDir = ".", build_doc = FALSE, testDir = 'Tests'){
  testFiles <- getTests(pluginDir, testDir)
  dirs <- dirNames()
  testDir <- file.path(pluginDir, dirs$extras, testDir)
  results <- lapply(testFiles, runWorkflow2)
  if (build_doc){
    with_dir_(testDir, {
      saveRDS(results, '_testResults.rds')
      rmarkdown::render('README.Rmd')
      browseURL('README.html')
    })
  }
  return(results)
}

# Get all test workflows in a plugin folder.
getTests <- function(pluginDir = ".", testDir = 'Tests'){
  dirs <- dirNames()
  test_dir <- file.path(pluginDir, dirs$extras, testDir)
  if (!dir.exists(test_dir)){
    test_dir <- file.path(pluginDir, 'Supporting_Macros', 'tests')
  }
  f <- list.files(test_dir, pattern = '.yxmd', full = TRUE)
  if (!getOption('ayxhelper.xdf', FALSE) && length(grep("XDF", f) > 0)){
    message("Ignoring XDF related tests.")
    f <- f[-grep("XDF", f)]
  }
  return(f)
}

# Parse results obtained from running a test workflow.
parseResult <- function(result){
  r2 <- stringr::str_split(tail(result, 1), '\\s+with\\s+')[[1]]
  status <- ifelse(is.null(attr(result, 'status')), 0, attr(result, 'status'))
  r3 <- list(
    status = if(status <= 1) ":smile:" else ":rage:",
    time = stringr::str_match(r2[1], "^Finished in (.*)")[,2],
    message = ifelse(is.na(r2[2]), "", r2[2]),
    log = paste(result, collapse = '\n')
  )
}