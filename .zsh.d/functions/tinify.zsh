function tinify() {
  [[ -z $1 ]] || [[ -z $2 ]] && echo 'Usage: tinify [input] [output] *[size] *[width or height]' && return 1

  local input=$1
  local output=$2
  local size=$3
  local tax=`[[ -z $4 ]] && echo width || echo $4`
  local api=nFZdkWRFXCKg0wNslk1xPy-JpGQytE_Y
  local uploaded=`curl -s https://api.tinify.com/shrink \
                   --user api:$api \
                   --dump-header /dev/stdout \
                   --data-binary @$input \
                   | grep Location | cut -d' ' -f2 | tr -d '\r\n'`

  if [[ -z $size ]]; then
    curl -s $uploaded --user api:$api --output $output
  else
    # widthかheight以外なら終了
    [[ $tax -eq 'width' ]] || [[ $tax -eq 'height' ]] || return 1


    local json=`[[ $tax = 'width' ]] \
                && echo "{\"resize\":{\"method\":\"scale\",\"width\":$size}}" \
                || echo "{\"resize\":{\"method\":\"scale\",\"height\":$size}}"`
    curl -s $uploaded --user api:$api --output $output \
    --header 'Content-Type: application/json' \
    --data $json
  fi

  # 最後に出力ファイル名を表示
  echo 'Created' $output
}
