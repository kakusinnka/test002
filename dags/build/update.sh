#!/bin/bash

if [ -e tmp ]
then
rm -rf tmp
mkdir tmp
chmod 777 tmp
echo '已删除并重新创建 tmp 目录'
else
mkdir tmp
chmod 777 tmp
echo 'tmp 目录不存在，已创建'
fi

echo start 
pwd
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
    ownerStr="'owner': 'max',"
    echo $ownerStr
    sed -i "${line}i \    $ownerStr" $FILE
done