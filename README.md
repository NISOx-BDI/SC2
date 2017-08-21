# Project template

This is a data management templete for github used by the *Neuroimaging Statistics Oxford (NISOx)* reserach group. This README file should cointain the most relevant information, and also a link to the publication. A github markdown cheat sheet is available [here] (https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)

## Folder structure
There should be a general consensus on the folder structure, but extensions and adjustments are are possible.

	.
	|-- CITATION
	|-- README.md
	|-- LICENSE
	|-- requirements.txt
	|-- data
	|   -- birds_count_table.csv
        |   -- raw
        |   -- processed
	|-- doc
	|   -- notebook.md
	|   -- manuscript.md
	|   -- changelog.txt
	|-- results
	|   -- summarized_results.csv
	|-- src
	|   -- sightings_analysis.py
	|   -- runall.py


The `data` folder can have subfolder for different stages of processing, for example `raw`, `processed`.

## Notebooks

There are different types of notebooks, and some are directly rendered by github. For R Notebooks, a `htmlpreview` prefix to the URL can be used to render the notebook, for example

- [R Notebook](http://htmlpreview.github.com/?https://github.com/schw4b/dm-template/blob/master/analysis/ProjectName.html)


## Further readings

- (Cookiecutter Data Science)[https://drivendata.github.io/cookiecutter-data-science/]
- (Good Enough Practices for Scientific Computing)[https://swcarpentry.github.io/good-enough-practices-in-scientific-computing/#project-organization]
