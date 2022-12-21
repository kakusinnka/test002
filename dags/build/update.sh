#!/bin/bash
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
done

zip -r sandbox.zip ./tmp/*.py
ls

rm -rf tmp
ls

gsutil cp gs://asia-northeast1-hzh-compose-420191cc-bucket/dags sandbox.zip