"java-dashboard": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployment"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "A trait to add a dashboard for Java applications"
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		"java-dashboard": {
			apiVersion: "integreatly.org/v1alpha1"
			kind:       "GrafanaDashboard"
			metadata: {
				name: "java-dashboard-" + context.name
				labels: {
					dashboard: "application"
				}
			}
			spec: json: """
			{
				"annotations": {
					"list": [
						{
							"builtIn": 1,
							"datasource": {
								"type": "datasource",
								"uid": "grafana"
							},
							"enable": true,
							"hide": true,
							"iconColor": "rgba(0, 211, 255, 1)",
							"name": "Annotations & Alerts",
							"target": {
								"limit": 100,
								"matchAny": false,
								"tags": [],
								"type": "dashboard"
							},
							"type": "dashboard"
						}
					]
				},
				"description": "MicroProfile Metrics Endpoint Monitoring",
				"editable": true,
				"fiscalYearStartMonth": 0,
				"gnetId": 12853,
				"graphTooltip": 0,
				"id": 18,
				"links": [],
				"liveNow": false,
				"panels": [
					{
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"fieldConfig": {
							"defaults": {
								"color": {
									"mode": "thresholds"
								},
								"mappings": [
									{
										"options": {
											"0": {
												"text": "DOWN"
											},
											"1": {
												"text": "UP"
											}
										},
										"type": "value"
									}
								],
								"thresholds": {
									"mode": "absolute",
									"steps": [
										{
											"color": "#d44a3a",
											"value": null
										},
										{
											"color": "#37872D",
											"value": 1
										},
										{
											"color": "#FADE2A"
										}
									]
								},
								"unit": "none"
							},
							"overrides": []
						},
						"gridPos": {
							"h": 2,
							"w": 4,
							"x": 0,
							"y": 0
						},
						"id": 29,
						"links": [],
						"maxDataPoints": 100,
						"options": {
							"colorMode": "background",
							"graphMode": "none",
							"justifyMode": "auto",
							"orientation": "horizontal",
							"reduceOptions": {
								"calcs": [
									"lastNotNull"
								],
								"fields": "",
								"values": false
							},
							"textMode": "auto"
						},
						"pluginVersion": "9.3.1",
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"editorMode": "code",
								"expr": "up{job=\\"$serviceID\\", instance=\\"$instance\\"}",
								"range": true,
								"refId": "A"
							}
						],
						"title": "Status",
						"type": "stat"
					},
					{
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"description": " base_jvm_uptime_seconds Displays the uptime of the JVM in milliseconds.",
						"fieldConfig": {
							"defaults": {
								"color": {
									"mode": "thresholds"
								},
								"mappings": [
									{
										"options": {
											"match": "null",
											"result": {
												"text": "N/A"
											}
										},
										"type": "special"
									}
								],
								"thresholds": {
									"mode": "absolute",
									"steps": [
										{
											"color": "green",
											"value": null
										},
										{
											"color": "red",
											"value": 80
										}
									]
								},
								"unit": "s"
							},
							"overrides": []
						},
						"gridPos": {
							"h": 2,
							"w": 3,
							"x": 4,
							"y": 0
						},
						"id": 26,
						"links": [],
						"maxDataPoints": 100,
						"options": {
							"colorMode": "none",
							"graphMode": "none",
							"justifyMode": "auto",
							"orientation": "horizontal",
							"reduceOptions": {
								"calcs": [
									"lastNotNull"
								],
								"fields": "",
								"values": false
							},
							"textMode": "auto"
						},
						"pluginVersion": "9.3.1",
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"editorMode": "code",
								"expr": "base_jvm_uptime_seconds{instance=\\"$instance\\", job=\\"$serviceID\\"}",
								"range": true,
								"refId": "A"
							}
						],
						"title": "Uptime",
						"type": "stat"
					},
					{
						"aliasColors": {},
						"bars": false,
						"dashLength": 10,
						"dashes": false,
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"description": "base_gc_total_total Displays the total number of collections that have occurred. This attribute lists -1 if the collection count is undefined for this collector.",
						"fieldConfig": {
							"defaults": {
								"links": []
							},
							"overrides": []
						},
						"fill": 1,
						"fillGradient": 0,
						"gridPos": {
							"h": 8,
							"w": 8,
							"x": 7,
							"y": 0
						},
						"hiddenSeries": false,
						"id": 14,
						"legend": {
							"alignAsTable": true,
							"avg": true,
							"current": true,
							"max": true,
							"min": true,
							"show": true,
							"total": false,
							"values": true
						},
						"lines": true,
						"linewidth": 1,
						"links": [],
						"nullPointMode": "null",
						"options": {
							"alertThreshold": true
						},
						"percentage": false,
						"pluginVersion": "9.3.1",
						"pointradius": 2,
						"points": false,
						"renderer": "flot",
						"seriesOverrides": [],
						"spaceLength": 10,
						"stack": false,
						"steppedLine": false,
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"editorMode": "code",
								"expr": "rate(base_gc_total{instance=\\"$instance\\", job=\\"$serviceID\\"}[5m])",
								"intervalFactor": 2,
								"legendFormat": "{{ name }}",
								"range": true,
								"refId": "A"
							}
						],
						"thresholds": [],
						"timeRegions": [],
						"title": "GC Copy & Mark Sweep Total",
						"tooltip": {
							"shared": true,
							"sort": 0,
							"value_type": "individual"
						},
						"type": "graph",
						"xaxis": {
							"mode": "time",
							"show": true,
							"values": []
						},
						"yaxes": [
							{
								"format": "short",
								"logBase": 1,
								"show": true
							},
							{
								"format": "short",
								"logBase": 1,
								"show": true
							}
						],
						"yaxis": {
							"align": false
						}
					},
					{
						"aliasColors": {},
						"bars": false,
						"dashLength": 10,
						"dashes": false,
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"description": "base_gc_time_total Displays the approximate accumulated collection elapsed time in milliseconds. This attribute displays -1 if the collection elapsed time is undefined for this collector. The JVM implementation may use a high resolution timer to measure the elapsed time. This attribute may display the same value even if the collection count has been incremented if the collection elapsed time is very short.",
						"fieldConfig": {
							"defaults": {
								"links": []
							},
							"overrides": []
						},
						"fill": 1,
						"fillGradient": 0,
						"gridPos": {
							"h": 8,
							"w": 8,
							"x": 15,
							"y": 0
						},
						"hiddenSeries": false,
						"id": 12,
						"legend": {
							"alignAsTable": true,
							"avg": true,
							"current": true,
							"max": true,
							"min": true,
							"rightSide": false,
							"show": true,
							"total": false,
							"values": true
						},
						"lines": true,
						"linewidth": 1,
						"links": [],
						"nullPointMode": "null",
						"options": {
							"alertThreshold": true
						},
						"percentage": false,
						"pluginVersion": "9.3.1",
						"pointradius": 2,
						"points": false,
						"renderer": "flot",
						"seriesOverrides": [],
						"spaceLength": 10,
						"stack": false,
						"steppedLine": false,
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"editorMode": "code",
								"expr": "rate(base_gc_time_total_seconds{instance=\\"$instance\\", job=\\"$serviceID\\"}[5m])",
								"legendFormat": "{{ name }}",
								"range": true,
								"refId": "A"
							}
						],
						"thresholds": [],
						"timeRegions": [],
						"title": "GC Copy & Mark Sweep Time",
						"tooltip": {
							"shared": true,
							"sort": 0,
							"value_type": "individual"
						},
						"type": "graph",
						"xaxis": {
							"mode": "time",
							"show": true,
							"values": []
						},
						"yaxes": [
							{
								"format": "ms",
								"logBase": 1,
								"show": true
							},
							{
								"format": "short",
								"logBase": 1,
								"show": false
							}
						],
						"yaxis": {
							"align": false
						}
					},
					{
						"aliasColors": {},
						"bars": false,
						"dashLength": 10,
						"dashes": false,
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"description": "",
						"fieldConfig": {
							"defaults": {
								"links": []
							},
							"overrides": []
						},
						"fill": 1,
						"fillGradient": 0,
						"gridPos": {
							"h": 6,
							"w": 7,
							"x": 0,
							"y": 2
						},
						"hiddenSeries": false,
						"id": 8,
						"legend": {
							"alignAsTable": true,
							"avg": true,
							"current": true,
							"max": true,
							"min": true,
							"show": true,
							"total": false,
							"values": true
						},
						"lines": true,
						"linewidth": 1,
						"links": [],
						"nullPointMode": "null",
						"options": {
							"alertThreshold": true
						},
						"percentage": false,
						"pluginVersion": "9.3.1",
						"pointradius": 5,
						"points": false,
						"renderer": "flot",
						"seriesOverrides": [],
						"spaceLength": 10,
						"stack": false,
						"steppedLine": false,
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"editorMode": "code",
								"expr": "vendor_system_cpu_load{instance=\\"$instance\\",job=\\"$serviceID\\"}",
								"intervalFactor": 2,
								"legendFormat": "CPU load",
								"range": true,
								"refId": "A"
							}
						],
						"thresholds": [],
						"timeRegions": [],
						"title": "CPU Load",
						"tooltip": {
							"shared": true,
							"sort": 0,
							"value_type": "individual"
						},
						"type": "graph",
						"xaxis": {
							"mode": "time",
							"show": true,
							"values": []
						},
						"yaxes": [
							{
								"format": "percentunit",
								"logBase": 1,
								"show": true
							},
							{
								"format": "short",
								"logBase": 1,
								"show": false
							}
						],
						"yaxis": {
							"align": false
						}
					},
					{
						"aliasColors": {},
						"bars": false,
						"dashLength": 10,
						"dashes": false,
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"fieldConfig": {
							"defaults": {
								"links": []
							},
							"overrides": []
						},
						"fill": 1,
						"fillGradient": 0,
						"gridPos": {
							"h": 9,
							"w": 23,
							"x": 0,
							"y": 8
						},
						"hiddenSeries": false,
						"hideTimeOverride": false,
						"id": 10,
						"interval": "",
						"legend": {
							"alignAsTable": true,
							"avg": true,
							"current": true,
							"max": true,
							"min": true,
							"rightSide": false,
							"show": true,
							"total": false,
							"values": true
						},
						"lines": true,
						"linewidth": 1,
						"links": [],
						"nullPointMode": "null",
						"options": {
							"alertThreshold": true
						},
						"percentage": false,
						"pluginVersion": "9.3.1",
						"pointradius": 5,
						"points": false,
						"renderer": "flot",
						"seriesOverrides": [],
						"spaceLength": 10,
						"stack": false,
						"steppedLine": false,
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"expr": "base_memory_usedHeap_bytes{instance=\\"$instance\\",job=\\"$serviceID\\"}",
								"intervalFactor": 2,
								"legendFormat": "Used Heap",
								"refId": "A"
							},
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"expr": "base_memory_committedHeap_bytes{instance=\\"$instance\\", job=\\"$serviceID\\"}",
								"intervalFactor": 2,
								"legendFormat": "Commited Heap",
								"refId": "C"
							},
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"expr": "base_memory_maxHeap_bytes{instance=\\"$instance\\", job=\\"$serviceID\\"}",
								"intervalFactor": 2,
								"legendFormat": "Max Heap",
								"refId": "B"
							}
						],
						"thresholds": [],
						"timeRegions": [],
						"title": "Heap Sizes",
						"tooltip": {
							"shared": true,
							"sort": 2,
							"value_type": "individual"
						},
						"type": "graph",
						"xaxis": {
							"mode": "time",
							"show": true,
							"values": []
						},
						"yaxes": [
							{
								"format": "decbytes",
								"logBase": 1,
								"show": true
							},
							{
								"format": "short",
								"logBase": 1,
								"show": false
							}
						],
						"yaxis": {
							"align": false
						}
					},
					{
						"aliasColors": {},
						"bars": false,
						"dashLength": 10,
						"dashes": false,
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"fieldConfig": {
							"defaults": {
								"links": []
							},
							"overrides": []
						},
						"fill": 1,
						"fillGradient": 0,
						"gridPos": {
							"h": 6,
							"w": 10,
							"x": 0,
							"y": 17
						},
						"hiddenSeries": false,
						"id": 2,
						"legend": {
							"alignAsTable": true,
							"avg": true,
							"current": true,
							"max": true,
							"min": true,
							"rightSide": false,
							"show": true,
							"total": false,
							"values": true
						},
						"lines": true,
						"linewidth": 1,
						"links": [],
						"nullPointMode": "null",
						"options": {
							"alertThreshold": true
						},
						"percentage": false,
						"pluginVersion": "9.3.1",
						"pointradius": 5,
						"points": false,
						"renderer": "flot",
						"seriesOverrides": [],
						"spaceLength": 10,
						"stack": false,
						"steppedLine": false,
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"expr": "base_thread_count{instance=\\"$instance\\",job=\\"$serviceID\\"}",
								"intervalFactor": 2,
								"legendFormat": "Thread Count",
								"refId": "A"
							}
						],
						"thresholds": [],
						"timeRegions": [],
						"title": "Thread Count",
						"tooltip": {
							"shared": true,
							"sort": 0,
							"value_type": "individual"
						},
						"type": "graph",
						"xaxis": {
							"mode": "time",
							"show": true,
							"values": []
						},
						"yaxes": [
							{
								"format": "short",
								"logBase": 1,
								"show": true
							},
							{
								"format": "short",
								"logBase": 1,
								"show": false
							}
						],
						"yaxis": {
							"align": false
						}
					},
					{
						"aliasColors": {},
						"bars": false,
						"dashLength": 10,
						"dashes": false,
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"fieldConfig": {
							"defaults": {
								"links": []
							},
							"overrides": []
						},
						"fill": 1,
						"fillGradient": 0,
						"gridPos": {
							"h": 6,
							"w": 10,
							"x": 10,
							"y": 17
						},
						"hiddenSeries": false,
						"hideTimeOverride": false,
						"id": 27,
						"interval": "",
						"legend": {
							"alignAsTable": true,
							"avg": true,
							"current": true,
							"max": true,
							"min": true,
							"rightSide": false,
							"show": true,
							"total": false,
							"values": true
						},
						"lines": true,
						"linewidth": 1,
						"links": [],
						"nullPointMode": "null",
						"options": {
							"alertThreshold": true
						},
						"percentage": false,
						"pluginVersion": "9.3.1",
						"pointradius": 5,
						"points": false,
						"renderer": "flot",
						"seriesOverrides": [],
						"spaceLength": 10,
						"stack": false,
						"steppedLine": false,
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"expr": "base_memory_usedNonHeap_bytes{instance=\\"$instance\\",job=\\"$serviceID\\"}",
								"intervalFactor": 2,
								"legendFormat": "Used Non Heap",
								"refId": "A"
							},
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"expr": "base_memory_committedNonHeap_bytes{instance=\\"$instance\\",job=\\"$serviceID\\"}",
								"intervalFactor": 2,
								"legendFormat": "Commited Non Heap",
								"refId": "B"
							}
						],
						"thresholds": [],
						"timeRegions": [],
						"title": "Non Heap Sizes",
						"tooltip": {
							"shared": true,
							"sort": 0,
							"value_type": "individual"
						},
						"type": "graph",
						"xaxis": {
							"mode": "time",
							"show": true,
							"values": []
						},
						"yaxes": [
							{
								"format": "decbytes",
								"logBase": 1,
								"show": true
							},
							{
								"format": "short",
								"logBase": 1,
								"show": true
							}
						],
						"yaxis": {
							"align": false
						}
					},
					{
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"description": "base_classloader_loadedClasses_count Displays the number of classes that are currently loaded in the JVM.",
						"fieldConfig": {
							"defaults": {
								"color": {
									"mode": "thresholds"
								},
								"mappings": [
									{
										"options": {
											"match": "null",
											"result": {
												"text": "N/A"
											}
										},
										"type": "special"
									}
								],
								"thresholds": {
									"mode": "absolute",
									"steps": [
										{
											"color": "green",
											"value": null
										},
										{
											"color": "red",
											"value": 80
										}
									]
								},
								"unit": "none"
							},
							"overrides": []
						},
						"gridPos": {
							"h": 2,
							"w": 3,
							"x": 20,
							"y": 17
						},
						"id": 20,
						"links": [],
						"maxDataPoints": 100,
						"options": {
							"colorMode": "none",
							"graphMode": "none",
							"justifyMode": "auto",
							"orientation": "horizontal",
							"reduceOptions": {
								"calcs": [
									"mean"
								],
								"fields": "",
								"values": false
							},
							"textMode": "auto"
						},
						"pluginVersion": "9.3.1",
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"expr": "base_classloader_loadedClasses_count{instance=\\"$instance\\", job=\\"$serviceID\\"}",
								"refId": "A"
							}
						],
						"title": "Currently loaded Classes",
						"type": "stat"
					},
					{
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"description": "base_classloader_loadedClasses_total_total Displays the total number of classes that have been loaded since the JVM has started execution.",
						"fieldConfig": {
							"defaults": {
								"color": {
									"mode": "thresholds"
								},
								"mappings": [
									{
										"options": {
											"match": "null",
											"result": {
												"text": "N/A"
											}
										},
										"type": "special"
									}
								],
								"thresholds": {
									"mode": "absolute",
									"steps": [
										{
											"color": "green",
											"value": null
										},
										{
											"color": "red",
											"value": 80
										}
									]
								},
								"unit": "none"
							},
							"overrides": []
						},
						"gridPos": {
							"h": 2,
							"w": 3,
							"x": 20,
							"y": 19
						},
						"id": 23,
						"links": [],
						"maxDataPoints": 100,
						"options": {
							"colorMode": "none",
							"graphMode": "none",
							"justifyMode": "auto",
							"orientation": "horizontal",
							"reduceOptions": {
								"calcs": [
									"mean"
								],
								"fields": "",
								"values": false
							},
							"textMode": "auto"
						},
						"pluginVersion": "9.3.1",
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"editorMode": "code",
								"expr": "base_classloader_loadedClasses_total{instance=\\"$instance\\", job=\\"$serviceID\\"}",
								"range": true,
								"refId": "A"
							}
						],
						"title": "Total loaded Classes",
						"type": "stat"
					},
					{
						"datasource": {
							"type": "prometheus",
							"uid": "prometheus"
						},
						"description": "base_classloader_unloadedClasses_total_total Displays the total number of classes unloaded since the JVM has started execution.",
						"fieldConfig": {
							"defaults": {
								"color": {
									"mode": "thresholds"
								},
								"mappings": [
									{
										"options": {
											"match": "null",
											"result": {
												"text": "N/A"
											}
										},
										"type": "special"
									}
								],
								"thresholds": {
									"mode": "absolute",
									"steps": [
										{
											"color": "green",
											"value": null
										},
										{
											"color": "red",
											"value": 80
										}
									]
								},
								"unit": "none"
							},
							"overrides": []
						},
						"gridPos": {
							"h": 2,
							"w": 3,
							"x": 20,
							"y": 21
						},
						"id": 24,
						"links": [],
						"maxDataPoints": 100,
						"options": {
							"colorMode": "none",
							"graphMode": "none",
							"justifyMode": "auto",
							"orientation": "horizontal",
							"reduceOptions": {
								"calcs": [
									"mean"
								],
								"fields": "",
								"values": false
							},
							"textMode": "auto"
						},
						"pluginVersion": "9.3.1",
						"targets": [
							{
								"datasource": {
									"type": "prometheus",
									"uid": "prometheus"
								},
								"editorMode": "code",
								"expr": "base_classloader_unloadedClasses_total{instance=\\"$instance\\", job=\\"$serviceID\\"}",
								"range": true,
								"refId": "A"
							}
						],
						"title": "Total unloaded Classes",
						"type": "stat"
					}
				],
				"refresh": "",
				"schemaVersion": 37,
				"style": "dark",
				"tags": [],
				"templating": {
					"list": [
						{
							"description": "",
							"hide": 2,
							"label": "ServiceID",
							"name": "serviceID",
							"query": "\(context.name)",
							"skipUrlSync": false,
							"type": "constant"
						},
						{
							"current": {
								"selected": false,
								"text": "10.131.0.40:8443",
								"value": "10.131.0.40:8443"
							},
							"datasource": {
								"type": "prometheus",
								"uid": "prometheus"
							},
							"definition": "label_values(base_gc_total{job=\\"$serviceID\\"}, instance)",
							"hide": 0,
							"includeAll": false,
							"multi": false,
							"name": "instance",
							"options": [],
							"query": {
								"query": "label_values(base_gc_total{job=\\"$serviceID\\"}, instance)",
								"refId": "StandardVariableQuery"
							},
							"refresh": 1,
							"regex": "",
							"skipUrlSync": false,
							"sort": 0,
							"tagValuesQuery": "",
							"tagsQuery": "",
							"type": "query",
							"useTags": false
						}
					]
				},
				"time": {
					"from": "now-6h",
					"to": "now"
				},
				"timepicker": {
					"refresh_intervals": [
						"5s",
						"10s",
						"30s",
						"1m",
						"5m",
						"15m",
						"30m",
						"1h",
						"2h",
						"1d"
					],
					"time_options": [
						"5m",
						"15m",
						"1h",
						"6h",
						"12h",
						"24h",
						"2d",
						"7d",
						"30d"
					]
				},
				"timezone": "",
				"title": "\(context.name) Java Metrics",
				"uid": "\(parameter.uid)",
				"version": 2,
				"weekStart": ""
			}
			"""
		}
	}
	parameter: {
		// +usage=Override uid of this dashboard, useful to prevent collisions. Default value: Component name
		uid: *context.name | string
	}
}
