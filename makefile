$(VERBOSE).SILENT:
usage:
	echo "USAGE:"
	echo "make preflight		Run prerequisite checks."
	echo "make auth		Authenticate aws cli with web sso."
	echo "make sync-s3		Download/sync csv reports to dataDir"
preflight:
	echo "checking ..."
	type aws >/dev/null 2>&1 || { echo >&2 "aws-cli is not installed.  See https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html for steps."; exit 1; }
	echo "aws-cli is installed."
sync-s3: preflight
	mkdir -p dataDir
	aws s3 sync s3://securiti-cx-exports/cx/ dataDir
auth: preflight
	mkdir -p backup 
	if [ -d ~/.aws ]; then echo "Backing up ~/.aws"; cp -r ~/.aws backup/ && rm -R ~/.aws; fi
	mkdir -p ~/.aws
	cp config ~/.aws
	aws sso login --no-browser