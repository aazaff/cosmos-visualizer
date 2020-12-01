all:
	bin/run-frontend --production visualizer

tagger:
	bin/run-tagging

xdd:
	docker build -t xdd_cosmos_visualizer:latest -f frontend-shared/Dockerfile.xdd frontend-shared
	docker run -p 8080:80 xdd_cosmos_visualizer:latest

xdd-tagging:
	docker build -t xdd_cosmos_tagging:latest -f frontend-shared/Dockerfile.xdd-tagging frontend-shared
	docker run -p 8080:80 xdd_cosmos_tagging:latest
