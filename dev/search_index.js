var documenterSearchIndex = {"docs":
[{"location":"#","page":"Home","title":"Home","text":"This repository contains Jupyter notebooks used in MEA-412: Atmospheric Physics  (Course Catalog)  taught in the Department of Marine, Earth and Atmospheric Sciences at NC State University.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Instructor/Author: Markus Petters","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Some of the images are taken from other sources. Please see License for author credits.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"The notebooks can be executed in the browser through Binder.","category":"page"},{"location":"#","page":"Home","title":"Home","text":"(Image: Binder)","category":"page"},{"location":"#","page":"Home","title":"Home","text":"The notebooks can also be executed locally, following the installation instructions","category":"page"},{"location":"#Instructors-1","page":"Home","title":"Instructors","text":"","category":"section"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Install the Long-term support (LTS) release of julia from https://julialang.org/downloads/. ","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Once installed start the julia REPL (Read-Eval-Print-Loop)","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"              _\n   _       _ _(_)_     |  Documentation: https://docs.julialang.org\n  (_)     | (_) (_)    |\n   _ _   _| |_  __ _   |  Type \"?\" for help, \"]?\" for Pkg help.\n  | | | | | | |/ _` |  |\n  | | |_| | | | (_| |  |  Version 1.0.5 (2019-09-09)\n _/ |\\__'_|_|_|\\__'_|  |  Official https://julialang.org/ release\n|__/                   |\n\njulia>","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"At the prompt type ","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> ]","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"to start the package manager. Then, add the following julia packages:","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"pkg> add Gadfly Interact WebIO IJulia","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Next, install the Jupyter notebook server","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> using IJulia\njulia> notebook()","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Next, exit the notbook and exit out of the julia REPL session. Restart the REPL. and install the WebIO Jupyter extension:","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> using WebIO\njulia> WebIO.install_jupyter_nbextension()","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Finally, download the ZIP'ed notebooks from GitHub: MEA-412-Notebooks","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"(Image: alt text)","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Extract the ZIP file to location of your choice (e.g. Desktop).  Start the notebook server:","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"julia> using IJulia\njulia> notebook()","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"Navigate to the extracted folder and open any of the notebooks.","category":"page"},{"location":"installation/#","page":"Local Installation","title":"Local Installation","text":"(Image: alt text)","category":"page"},{"location":"license/#","page":"License","title":"License","text":"This is a mixed license repository. ","category":"page"},{"location":"license/#Software-1","page":"License","title":"Software","text":"","category":"section"},{"location":"license/#","page":"License","title":"License","text":"Software provided within this repository is copyrighted by the author of the repository and licensed under the GNU General Public License.  Software includes all julia scripts and code within the Jupyter notebooks.","category":"page"},{"location":"license/#Images-1","page":"License","title":"Images","text":"","category":"section"},{"location":"license/#","page":"License","title":"License","text":"Images created by the author of the repository are licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (CC BY-NC-SA 4.0) Human Readable Format or  Full Text. Other images are licensed as indicated.","category":"page"},{"location":"license/#Warm-Cloud-Formation-1","page":"License","title":"Warm Cloud Formation","text":"","category":"section"},{"location":"license/#","page":"License","title":"License","text":"","category":"page"},{"location":"license/#","page":"License","title":"License","text":"File: src/Warm Cloud Formation/figures/cloud_formation.png \nAuthor/License: Markus Petters/CC BY-NC-SA 4.0","category":"page"},{"location":"license/#","page":"License","title":"License","text":"","category":"page"},{"location":"license/#","page":"License","title":"License","text":"File: src/Warm Cloud Formation/figures/cloud1.jpg\nAuthor/License: Versageek/CC BY-SA 3.0  via Wikimedia Commons\\  \nSource","category":"page"},{"location":"license/#","page":"License","title":"License","text":"","category":"page"},{"location":"license/#","page":"License","title":"License","text":"File: src/Warm Cloud Formation/figures/cloud2.jpg \nAuthor/License: Ximonic, Simo Räsänen/GFDL, via Wikimedia Commons \nSource","category":"page"},{"location":"license/#","page":"License","title":"License","text":"","category":"page"},{"location":"license/#","page":"License","title":"License","text":"File: src/Warm Cloud Formation/figures/ccn_chamer.png \nAuthor/License: Markus Petters/CC BY-NC-SA 4.0","category":"page"},{"location":"license/#","page":"License","title":"License","text":"","category":"page"},{"location":"license/#","page":"License","title":"License","text":"File: src/Warm Cloud Formation/figures/parcel_theory.png \nAuthor/License: Markus Petters/CC BY-NC-SA 4.0","category":"page"},{"location":"license/#Cloud-Growth-1","page":"License","title":"Cloud Growth","text":"","category":"section"}]
}
