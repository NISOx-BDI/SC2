# Project template

This is a data management templete for github used by the *Neuroimaging Statistics Oxford (NISOx)* reserach group. This README file should cointain the most relevant information, and also a link to the publication.

# Getting started
To get a copy of this template for your own project, please use GitHub import utility available at: [https://github.com/new/import](https://github.com/new/import), and:
 - under "old repository’s clone URL" enter https://github.com/NISOx-BDI/dm-template.git
 - Pick a Name for your project
 - Click "Begin Import"
 
This will ensure that your project is independent from this template repository (rather than being a fork).

## Markdown
A Github markdown cheat sheet is available from [here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).

## Folder structure
There should be a general consensus on the folder structure, but extensions and adjustments are are possible. If a dataset that is analyzed is open, it should contain a reference to the source, in the README.md

	.
	|-- CITATION
	|-- README.md
	|-- LICENSE
	|-- requirements.txt
	|-- data
	|   -- responde_time.csv
        |   -- raw
        |   -- processed
	|-- doc
	|   -- clincal_scores.doc
	|-- results
	|   -- 10_node_network
	    |  -- subj_01_node01.txt
	    |  -- subj_01_node02.txt
	|   -- summarized_results.csv
	|   -- ProjectName.Rmd
	|-- figures
	    -- fig1.png
	    -- fig2.png
	    -- time-series_ID057.png
	|-- src
	|   -- specific_analysis.py


## README.md

Mandatory.  A description of the repository, its citation, and information to help a user to get started with contents as quickly as possible.

## `CITATION`

Mandatory.  Provide information on how users of this shared repository should reference the the work. It may be the bibliographic reference of the paper that this repository supports, and/or data or software descriptor paper for the work.

## `LICENSE`

Mandatory.  The lab default license for the data shared is [CC-BY](https://creativecommons.org/licenses/by/3.0/), though ensure that the source of the data is compatible with this.  The lab default license for any scripts and code is [MIT](https://opensource.org/licenses/MIT), though pay special care that if code is derived from GPL-licensed code then the license must be GPL.

## `requirements.txt`

Mandatory.  List software tools and packages that the repository depends on.  If using Python, use [pip syntax](https://pip.pypa.io/en/stable/user_guide/#requirements-files).

## `data` directory

Mandatory.  Original source data and preprocessed data.  Summary data and derived data directly used to produces should `results` directory.

Organisation.  Simple projects may not need any subfolders, while large [....]

It is recommended that neuroimaging data should be represented in BIDS format.  Consider a "raw" folder that includes unprocessed versions of your data.

## `results` directory

Mandatory.  Summary data, derived data, scripts, notebooks, figures and tables.  The data in this directory is that needed to produce the results reported in paper text, tables and figures; the notebooks or scripts are those used to create said results.

General functions and scripts used to pre-process and generate derived data should be in the `src` directory.

Be sure to clearly name tables and figures.  Please use the following conventions:

 * `Fig_<num>_<label>.<ext>`
 * `Tab_<num>_<label>.<ext>`

For figures the best format is PDF, followed by PNG or TIFF.  Avoid JPEG at all costs.

For tables, always provide a CSV or TSV with column headers; if possible use full precision (i.e. avoid saving rounded values that may have been used for typsetting a table for publication).

## `src` directory

Mandatory. Library functions and scripts used to pre-process and generate derived data.  Scripts that directly generate results (tables or figures) should be in `results`.


## Notebooks

There are different types of notebooks, and some are directly rendered by Github.
### R Notebooks

For R Notebooks, [RawGit](https://rawgit.com/) serves raw html files directly from Github. To get an URL enter the link to the html files created by `knit`. Here is an example:

- [R Notebook](https://rawgit.com/NISOx-BDI/dm-template/master/results/ProjectName.html)
- [RawGit](https://rawgit.com/) provides a URL for development, use this so new changes you push will be reflected within minutes.


## Further readings

- [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/)
- [Good Enough Practices for Scientific Computing](https://swcarpentry.github.io/good-enough-practices-in-scientific-computing/#project-organization)
