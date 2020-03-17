library(shiny)
library(tiff)
library(ggplot2)
library(Seurat)

shinyServer(function(input, output, session) {
  
  output$legend <- renderImage({
    img_file <- if(input$dataset == "Toxseq_all_clusters_dataset1") {
      "Legend_allclusters.png"
    } else if (input$dataset == "Toxseq_microglia_dataset2") {
      "microglia_legend.png"
    } else "mono_mac_legend.png"
    list(src = img_file,
         width = 400,
         height = 100)
  }, deleteFile = FALSE)
  
  output$clusterNumUI <- renderUI({

    selectInput("clusterNum",
                "Choose a cluster",
                choices = levels(get(input$dataset)@meta.data$cluster_labels),
                selected = levels(get(input$dataset)@meta.data$cluster_labels)[1]
    )

  })

  output$mainUMAP <- renderImage({
    img_file <- if(input$dataset == "Toxseq_all_clusters_dataset1") {
      "Shiny_Allclusters_Figure.png"
    } else if (input$dataset == "Toxseq_microglia_dataset2") {
      "Shiny_Microglia_clusters_Figure.png"
    } else "Shiny_monocytes_figure.png"
    list(src = img_file,
         width = 380,
         height = 400
         )
  }, deleteFile = FALSE)

  output$geneExpDist <- renderPlot({

    FeaturePlot(get(input$dataset),
                feature = input$gene)

  })



  output$clusterWiseGeneExp <- renderPlot({

    VlnPlot(get(input$dataset),
            features = input$gene,
            group.by = "cluster_labels")

  })

  output$DEgenesTable <- renderDataTable({

    this_set <- substr(input$dataset, nchar(input$dataset),
                       nchar(input$dataset))
    this_data <- get(paste0("Dataset", this_set, "_all_DEGs"))
    this_data[, c(1:2, 5)] <- apply(this_data[, c(1:2, 5)],
                                    2, signif, digits = 3)
    subset(this_data,
           cluster == input$clusterNum)

  })
  
})
