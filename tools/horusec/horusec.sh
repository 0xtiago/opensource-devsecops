mkdir reports

#CRIA PASTA DE RELATÓRIO
mkdir reports

#CONFIGURAÇÃO DE PARÂMETROS DO HORUSEC
#image="0xtiago/horusec-cli"
image="horuszup/horusec-cli:v2.9.0-beta.3"
severity_exception="LOW,UNKNOWN,INFO"
report_type="text"
#report_path="reports/horusec_report.json"
ignore="**/tmp/**,
	      **/.vscode/**,\
				**/.venv/**, \
				**/.env/**, \
				**/tests/**, \
				**/test/**, \
				**/test/, \
				**/*.Tests/**, \
				**/*.Test/**, \
				**/test_*, \
				**/appsettings.*.json, \
				**/bin/Debug/*/appsettings.*.json, \
				**/*.yml, \
				**/bin/Debug/*/appsettings.json, \
				**/*.sarif" ;\


# EXECUTA CONTAINER DO HORUSEC REMOVENDO-O AO FIM DA EXECUÇÃO
docker pull $image
docker run --rm \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $(pwd):/src/horusec $image horusec start \
	-p /src/horusec -P $(pwd) \
	-o="$report_type" -O=/src/horusec/$report_path \
	-s=$severity_exception \
	--ignore=$ignore \
	--information-severity=true
	