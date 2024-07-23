#CONFIGURAÇÃO DE PARÂMETROS DO HORUSEC
#image="0xtiago/horusec-cli"
image="horuszup/horusec-cli:v2.9.0-beta.3"
severity_exception="LOW,UNKNOWN,INFO"
report_type="json"
report_directory="reports"
report_file="horusec_report.json"
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

#CRIA PASTA DE RELATÓRIO
[ -d $report_directory] && echo "Diretório já existe." || mkdir $report_directory 


# EXECUTA CONTAINER DO HORUSEC REMOVENDO-O AO FIM DA EXECUÇÃO
docker pull $image
docker run --rm \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $(pwd):/src/horusec $image horusec start \
	-p /src/horusec -P $(pwd) \
	-s=$severity_exception \
	--ignore=$ignore \
	--information-severity=true
	-o="$report_type" \
	-O=/src/horusec/$report_directory/$report_file
	