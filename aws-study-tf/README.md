※ファイル内の数値（12345 等）はテストのダミー値です

1.概要
Terraform で AWS 環境を構築するための学習用コードです。

2.前提条件
・検証用アカウントを使用するには、環境変数で AWS の認証情報を設定してください。
・デフォルトリージョンは ap-northeast-1 です。
・CI 実行時は plan ベースのテストが実行されます。
・CD 実行時は環境に apply されます。

3．テスト構成
・テストは plan ベースで実行されます。(terraform test)

4.CI/CD 構成
「CI」
・以下の４つのコマンドが実行されます。
terraform init/fmt/validate/test
・tf ファイル・tftest.hcl ファイル・CI/CD ファイルのいずれかが更新され、
main ブランチに対して PR を作成・更新・再作成する時、CI が走ります。

「CD」
CI が通過し、main ブランチに merge されると CD が走ります。
・terraform init/apply 　２つのコマンドが実行されます。
・CD 実行時は環境に apply されるため、必要に応じて terraform destroy を実行してください。
