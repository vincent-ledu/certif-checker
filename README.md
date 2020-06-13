# certif-checker

Shell scripts for checking certificates expiration

These scripts have been "stolen" to [Andrew](https://stackoverflow.com/users/538507/andrew) at https://stackoverflow.com/a/47878528/12325517 

The output format with dash padding has been "stolen" to [Fritz G. Mehner](https://stackoverflow.com/users/57457/fritz-g-mehner) at https://stackoverflow.com/a/4411098/12325517

## Usage

`$ ./check-certificate-expiration.sh < file-with-domain-name`

Output:
```
trello.com --------------------------- 77 days left
stackoverflow.com -------------------- 85 days left
google.fr ---------------------------- 66 days left
google.com --------------------------- 66 days left
```

If servers where are installed certificates are behind a loadbalancer, use:

`$ ./check-certificate-expiration-lb.sh < file-with-domain-name`

Output:
```
trello.com 104.93.247.29 ------------- 77 days left
stackoverflow.com 151.101.65.69 ------ 85 days left
stackoverflow.com 151.101.129.69 ----- 85 days left
stackoverflow.com 151.101.1.69 ------- 85 days left
stackoverflow.com 151.101.193.69 ----- 85 days left
google.fr 216.58.213.131 ------------- 66 days left
google.com 216.58.213.142 ------------ 66 days left
```

See `testfile.txt` and `runtest.sh` too for example.