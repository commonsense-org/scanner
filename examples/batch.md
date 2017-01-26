# Example batch usage

The following example will show usage of the batch processing using the data file 'alexatop20.csv' taken from Wikipedia's[https://en.wikipedia.org/wiki/List_of_most_popular_websites] Alexa's top site ranking in 2016/12/28.

```
./batch.sh -f 2 examples/data/alexatop20.csv
```

Note that we pass the value 2 to the 'field' parameter indicating that the second column in our csv contains the domain/path that we want to check.

The above command returns the following data.

```
domain,domain/,no,no,no
google.com,www.google.com/,no,yes,no
wikipedia.org,www.wikipedia.org/,yes,yes,yes
live.com,login.live.com/login.srf?wa=wsignin1.0&rpsnv=13&ct=1485453401&rver=6.4.6456.0&wp=MBI_SSL_SHARED&wreply=https:%2F%2Fmail.live.com%2Fdefault.aspx%3Frru%3Dinbox&lc=1033&id=64855&mkt=en-US&cbcxt=mai,yes,yes,yes
twitter.com,twitter.com/,yes,yes,no
google.co.jp,www.google.co.jp/,no,yes,no
amazon.com,www.amazon.com/,yes,no,no
instagram.com,www.instagram.com/,yes,yes,yes
reddit.com,www.reddit.com/,yes,no,no
facebook.com,www.facebook.com/,yes,yes,yes
google.co.in,www.google.co.in/,no,yes,no
yahoo.com,www.yahoo.com/,yes,yes,yes
google.de,www.google.de/,no,yes,no
qq.com,www.qq.com/,no,no,no
youtube.com,www.youtube.com/,yes,yes,yes
sohu.com,www.sohu.com/,no,yes,no
vk.com,m.vk.com/,yes,yes,no
taobao.com,world.taobao.com/,yes,yes,no
sina.com.cn,www.sina.com.cn/,no,yes,no
hao123.com,www.hao123.com/,no,yes,no
baidu.com,baidu.com/,no,yes,no

```

If we re-run the same command passing the `-k` flag we get the results returned in the same order as the source csv. Note that this will delay the output results so long running requests will slow down the overall process.

```
./batch.sh -k -f 2 examples/data/alexatop20.csv
```


```
domain,domain/,no,no,no
google.com,www.google.com/,no,yes,no
youtube.com,www.youtube.com/,yes,yes,yes
facebook.com,www.facebook.com/,yes,yes,yes
baidu.com,baidu.com/,no,yes,no
wikipedia.org,www.wikipedia.org/,yes,yes,yes
yahoo.com,www.yahoo.com/,yes,yes,yes
google.co.in,www.google.co.in/,no,yes,no
amazon.com,amazon.com/,no,no,no
qq.com,qq.com/,no,no,no
google.co.jp,www.google.co.jp/,no,yes,no
live.com,login.live.com/login.srf?wa=wsignin1.0&rpsnv=13&ct=1485453672&rver=6.4.6456.0&wp=MBI_SSL_SHARED&wreply=https:%2F%2Fmail.live.com%2Fdefault.aspx%3Frru%3Dinbox&lc=1033&id=64855&mkt=en-US&cbcxt=mai,yes,yes,yes
taobao.com,world.taobao.com/,yes,yes,no
vk.com,m.vk.com/,yes,yes,no
twitter.com,twitter.com/,yes,yes,no
instagram.com,www.instagram.com/,yes,yes,yes
hao123.com,www.hao123.com/,no,yes,no
sohu.com,www.sohu.com/,no,yes,no
sina.com.cn,www.sina.com.cn/,no,yes,no
reddit.com,www.reddit.com/,yes,no,no
google.de,www.google.de/,no,yes,no

```

Similarly we can increase or decrease the amount of concurrent connections that we run. Note that very large values can quickly saturate your network and/or overwhelm the amount of resources on your machine so use caution increasing this value.
