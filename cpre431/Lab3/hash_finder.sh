#!/bin/bash

filename="100k-most-used-passwords-NIST.txt"
output_hash="hashes.txt"
#password_hash='$6$xgLS35S6$2UjEq.dUhICPw9zgDVJXcQYQp/9ilLPQt/8Zgu0uwngI5mVvB1eKQG9SnVLjmOOfkB4Jjb5VSAXGXjY4Cf5k90'
#password_hash='$6$2Ff.cblr$QwoNFOAme5xy5/anjAsZVIDrZdBKZ.hZ6UIIdLU9D4DDEs3O.CbRsICaVxxdQOTG2TOHYSHDwfdsrG0WGsXVB/'
#password_hash='$6$zZKc4nOX$Rac9mB17TLeFgE/TOH0gTgRnAmaNk67ezuZo4fQAOSkulEKrrW6sum0uElLvmAeBqhf0k/jCYn2dddJCC0QzI1'
#password_hash='$6$dCPTizMy$b8Fiueet0w08JR66mI3UPg.U7ertejWDHTDCAyqbVSjhhLgTu8N2/51R496408q356m.gmJSjG.u89L.3K8HH.'
password_hash='$6$0Ptm7uW6$9cYOHvx3S6dJBgK4ZhVq.bPHJlaMH.KV/59bsX2UYVSBp6RUit6KKFLnuoKz5L5yHMH75YZymLcil9uBhV4XW.'
password_hash='$6$QpU0v3n/$Z5BKWAKu6SsZMI4KStZmlR/IZuhE9Ts.cezqBca3iApKmbT/GSBC1GUHf0I0mmytOdmqzclHkT47idGnpmHoe0'

 > "$output_hash"

while IFS= read -r line
do
        #hash=$(openssl passwd -6 -salt xgLS35S6 $line)
        #hash=$(openssl passwd -6 -salt zZKc4nOX $line)
        #hash=$(openssl passwd -6 -salt dCPTizMy $line)
        #hash=$(openssl passwd -6 -salt 0Ptm7uW6 $line)
        hash=$(openssl passwd -6 -salt QpU0v3n/ $line)
        #echo "$line $hash"
        #echo "$hash" >> "$output_hash"
        echo $hash
        #echo $password_hash

        if [ "$hash" = "$password_hash" ]; then
                #output_hash="$line"
                echo "$line" >> "$output_hash"
                break
        fi

done < "$filename"
