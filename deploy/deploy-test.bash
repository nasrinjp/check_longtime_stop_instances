#!/bin/bash

pwd

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
#cd /home/ec2-user/mean-community-Web/dist
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
