#!/bin/bash

################################################
# Deploy Shell
# argment 1:環境（dev,apiDev,staging,prod)
#         2:GitHubのbranch
################################################

## 引数チェック＆設定
if [ -z $1  ]; then
    echo "引数を指定してください。"
    exit 1
fi

env="$1"
if [ "$env" = "dev" ]; then
    s3_bucket="dev-test"
    cf_dist_id="E1AAA"
elif [ "$env" = "prod" ]; then
    s3_bucket="prod-test"
    cf_dist_id="E1BBB"
else
    echo "対象の環境はありません。引数を見直してください。"
    exit 1
fi

echo $s3_bucket 
echo $cf_dist_id
git status

# ライブラリインストール
echo ">>ライブラリインストール開始"
yarn --version
#yarn install
#[ $((${PIPESTATUS[@]/%/+}0)) -gt 0 ] && exit 1
echo ">>ライブラリインストール終了"
# ビルド
echo ">>ビルド開始"
#if [ "$env" = "prod" ]; then
#    yarn build
#else
#    yarn build:$env
#fi
#[ $((${PIPESTATUS[@]/%/+}0)) -gt 0 ] && exit 1
echo ">>ビルド終了"

# デプロイ
echo ">>>デプロイ開始"
aws --version
cd functions
pwd
aws sts get-caller-identity
# distフォルダへ移動
#cd /home/aaa/dist
# S3の資源を削除
#aws s3 rm s3://$s3_bucket/ --include '*' --recursive
#[ $((${PIPESTATUS[@]/%/+}0)) -gt 0 ] && exit 1
# S3へ資源をUpload
#aws s3 cp ./ s3://$s3_bucket/ --include '*' --recursive
#[ $((${PIPESTATUS[@]/%/+}0)) -gt 0 ] && exit 1
# CloudFrontのキャッシュクリア
#aws cloudfront create-invalidation --distribution-id $cf_dist_id --paths '/*'
#[ $((${PIPESTATUS[@]/%/+}0)) -gt 0 ] && exit 1
echo ">>>デプロイ完了"
