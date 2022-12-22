#!/bin/bash
start_date=$1
echo $start_date
echo start...
pwd
mkdir tmp
ls
cp -r *.py tmp/
ls tmp/
for FILE in tmp/*.py
  do
    echo $FILE
    oldDagIdLine=$(grep "^def " $FILE)
    echo $oldDagIdLine
    oldDagIdStr=${oldDagIdLine%:*}
    oldDagIdStr=${oldDagIdStr:4}
    echo $oldDagIdStr
    newDagIdStr=${oldDagIdStr%(*}"_sandbox()"
    echo $newDagIdStr
    sed -i "s/$oldDagIdStr/$newDagIdStr/" $FILE

    line=$(sed -n '/default_args/=' $FILE)
    ((line++))
    echo $line
    ownerStr="'owner': 'sandbox',"
    echo $ownerStr
    sed -i "${line}i \    $ownerStr" $FILE

    sed -i '/    start_date/c\    start_date=pendulum.datetime($start_date tz="Asia/Tokyo"),' $FILE
done

cd tmp
zip -r sandbox.zip ./*.py
ls

gsutil cp -r sandbox.zip gs://asia-northeast1-hzh-compose-420191cc-bucket/dags/

rm -rf ../tmp
ls
