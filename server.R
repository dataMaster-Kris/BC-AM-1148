#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# load("edited_data2.RData")
library(shiny)
library(tiff)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  output$legend <- renderImage({
    img_file <- if(input$dataset == "Toxseq_all_clusters_dataset1") {
      "Allclusters_legend.png"
    } else if (input$dataset == "Toxseq_microglia_dataset2") {
      "microglia_legend-01.png"
    } else "monocyte-macrophage_legend-01.png"
    list(src = img_file)
  }, deleteFile = FALSE)
  # output$legend <- renderPlot({
  #   p <- readTIFF("Allclusters_legend.tif")
  #   plot.new()
  #   rasterImage(p,0,0,1,1, native = TRUE)
  # })
  
  output$clusterNumUI <- renderUI({
    
    selectInput("clusterNum",
                "Choose a cluster",
                choices = levels(get(input$dataset)@meta.data$cluster_labels),
                selected = levels(get(input$dataset)@meta.data$cluster_labels)[1]
    )
    
  })
   
  output$mainUMAP <- renderPlot({
    
    DimPlot(get(input$dataset), 
            reduction = "umap") +
      ggtitle("Clusters")
    
  })
  
  output$variableUMAP <- renderPlot({
    
    DimPlot(get(input$dataset), 
            reduction = "umap",
            group.by = "toxseq_label") +
      scale_color_manual(values = c("black", "red", "grey")) +
      ggtitle("Tox-seq overlay")
    
  })
  
  output$geneExpDist <- renderPlot({
    
    FeaturePlot(get(input$dataset),
                feature = input$gene)
    
  })
  
  
  
  output$clusterWiseGeneExp <- renderPlot({
    
    VlnPlot(get(input$dataset),
            features = input$gene,
            group.by = "cluster_labels")
    
  })
  
  output$cellgroupWiseGeneExp <- renderPlot({
    
    VlnPlot(get(input$dataset),
            features = input$gene,
            group.by = "toxseq_label")
    
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
