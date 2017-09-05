# Project template

This is a data management templete for github used by the *Neuroimaging Statistics Oxford (NISOx)* reserach group. This README file should cointain the most relevant information, and also a link to the publication.

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


The `data` folder can have subfolder for different stages of processing, for example `raw`, `processed`.

## Notebooks

There are different types of notebooks, and some are directly rendered by Github.
### R Notebooks

For R Notebooks, [RawGit](https://rawgit.com/) serves raw html files directly from Github. To get an URL enter the link to the html files created by `knit`. Here is an example:

- [R Notebook](https://rawgit.com/NISOx-BDI/dm-template/master/results/ProjectName.html)
- [RawGit](https://rawgit.com/) provides a URL for development, use this so new changes you push will be reflected within minutes.


## Further readings

- [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/)
- [Good Enough Practices for Scientific Computing](https://swcarpentry.github.io/good-enough-practices-in-scientific-computing/#project-organization)
