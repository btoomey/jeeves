% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/svnfunctions.R
\name{saveManifest}
\alias{saveManifest}
\title{Save manifest of R packages installed.}
\usage{
saveManifest(svnDir = getOption("alteryx.svndir"), rVersion = getRversion())
}
\arguments{
\item{svnDir}{string indicating path to svn directory}

\item{rVersion}{string indicating version of R}
}
\description{
A detailed manifest of all R package installed in the SVN directory specified
by \code{svnDir} is built and saved to 
\code{3rdParty\\R\\Scripts\\packages.csv}. A plain list of R packages
installed is also saved to \code{3rdParty\\R\\Installer\\Readme.txt} Note
that both the manifest and the Readme are built based on packages installed
in the R library in the SVN directory and hence should not be manipulated
manually.
}

