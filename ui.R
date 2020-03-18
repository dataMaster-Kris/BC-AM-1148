library(shiny)
library(DT)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tox-seq viewer"),
  uiOutput("Link_to_paper"),
  verbatimTextOutput("blank"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("dataset",
                  "Choose a dataset",
                  choices = c("Tox-seq all clusters" = "Toxseq_all_clusters_dataset1",
                              "Tox-seq microglia sub-clusters" = "Toxseq_microglia_dataset2",
                              "Tox-seq monocytes/macrophages sub-clusters" = "Toxseq_mono.mac_dataset3"),
                  selected = "Tox-seq all clusters"
      ),
      
      selectInput("gene",
                  "Enter gene name",
                  choices = rownames(Toxseq_all_clusters_dataset1@assays$RNA),
                  selected = "Gpr34"
      ),
      
      uiOutput("clusterNumUI")
      
    ),
    
    mainPanel(
      
      imageOutput("legend", width = "100%", height = 120), 
      
      fluidRow(
        splitLayout(cellWidths = c("50%", "50%"),
                    imageOutput("mainUMAP", width = "100%"), #plotOutput("mainUMAP"), 
                    plotOutput("geneExpDist"))#, #plotOutput("variableUMAP"))
      ),
      
      plotOutput("clusterWiseGeneExp"),
      
      dataTableOutput("DEgenesTable")
      
    )
  )
))
