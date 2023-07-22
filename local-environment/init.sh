source .env

cd ../scripts
ls -la
pip3 install -r requirements.txt

python3 key_setup.py $MASTER_KEY $TABLES_SUFFIX

python3 setup.py admin@email.com $TABLES_SUFFIX