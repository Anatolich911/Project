fix-grafana-tls:
		kubectl delete secret grafana-tls -n grafana && \
		kubectl delete certificate grafana-tls -n grafana
	
fix-prometheus-tls:
		# delete prometheus certs
		kubectl delete secret prometheus-server-tls -n prometheus && \
		kubectl delete certificate prometheus-server-tls -n prometheus

fix-alertmanager-tls:
		kubectl delete secret alertmanager -n prometheus && \
		kubectl delete certificate alertmanager -n prometheus

fix-vault-tls:
		kubectl delete secret vault-tls -n vault && \
		kubectl delete certificate vault-tls -n vault

fix-argo-tls:
		kubectl delete secret argo-tls -n argocd && \
		kubectl delete certificate argo-tls -n argocd

fix-sftpgo-tls:
		kubectl delete secret sftpgo-tls -n sftpgo && \
		kubectl delete certificate sftpgo-tls -n sftpgo

fix-jenkins-tls:
		kubectl delete secret jenkins-tls -n jenkins && \
		kubectl delete certificate jenkins-tls -n jenkins
