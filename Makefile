develop:
	virtualenv -p python2 .env

deploy:
	.env/bin/pip install -r requirements.txt -t DIST
	cp ./main.py DIST/
	rm -rf dist.zip
	cd DIST; zip -r ../dist.zip *
	aws lambda update-function-code --function-name ECR_CLEANUP --zip-file fileb://dist.zip
	aws lambda update-function-configuration --function-name ECR_CLEANUP --timeout=300

create:
	aws lambda create-function-code --function-name ECR_CLEANUP --runtime python2.7 \
		--role arn:aws:iam::803559252216:role/LAMBDA_ECR_CLEANUP --handler main.handler --timeout 300 \
		--zip-file fileb://dist.zip
