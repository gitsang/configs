# Curl

## Install

```sh
mkdir -p ~/.curl
cp ./debug ~/.curl/debug
cp ./time ~/.curl/time
```

## Usage

```sh
curl www.baidu.com -w "%{time_total}"

curl www.baidu.com -w "@/path/to/.curl/time"

curl www.baidu.com -w "@/path/to/.curl/debug"
```
