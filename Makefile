site:
	. ./venv && ./makesite.py

dist:
	echo '{"index": "index.html"}' > params.json
	make site
	rm params.json

serve: site
	if python3 -c 'import http.server' 2> /dev/null; then \
	    echo Running Python3 http.server ...; \
	    python3 -m http.server; \
	elif python -c 'import http.server' 2> /dev/null; then \
	    echo Running Python http.server ...; \
	    python -m http.server; \
	elif python -c 'import SimpleHTTPServer' 2> /dev/null; then \
	    echo Running Python SimpleHTTPServer ...; \
	    python -m SimpleHTTPServer; \
	else \
	    echo Cannot find Python http.server or SimpleHTTPServer; \
	fi

venv: FORCE
	python3 -m venv ~/.venv/makesite
	echo . ~/.venv/makesite/bin/activate > venv
	. ./venv && pip install commonmark

publish: site
	git config user.name "publish"
	git config user.email "publish@localhost"
	git branch -D publish; :
	git switch --orphan publish
	mv _site/* .
	git add .
	git commit -m "Publish blog ($$(date -u +"%Y-%m-%d %H:%M:%S"))"
	git log -n 5
	git push -f origin publish

FORCE:
