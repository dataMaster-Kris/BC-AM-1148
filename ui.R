#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(Seurat)
library(DT)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tox-seq viewer"),
  
  # Sidebar with a slider input for number of bins 
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
      
      # selectInput("cellgroup",
      #             "Choose a variable",
      #             choices = c("All cells",
      #                         "Healthy Cd11b+ ROS- (grey)",
      #                         "EME CD11b+ ROS+ (black)",
      #                         "EAE CD11b+ ROS+ (red)"),
      #             selected = "All cells"
      # ),
      
      uiOutput("clusterNumUI")
      
      # numericInput("clusterNum", 
      #              "Choose a cluster number", 
      #              1, min = 1, max = 20)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      imageOutput("legend", height = 120), 
      
      # fluidRow(
      #   splitLayout(cellWidths = c("50%", "50%"),
      #               imageOutput("legend"))
      # ),
      # plotOutput("legend", height = "80%", width = "80%"),
      fluidRow(
        splitLayout(cellWidths = c("50%", "50%"),
                    plotOutput("mainUMAP"), 
                    plotOutput("variableUMAP"))
      ),
      
      plotOutput("geneExpDist"),
      
      plotOutput("clusterWiseGeneExp"),
      plotOutput("cellgroupWiseGeneExp"),
      
      dataTableOutput("DEgenesTable")
      
      # fluidRow(
      #   splitLayout(cellWidths = c("50%", "50%"),
      #               plotOutput("clusterWiseGeneExp"),
      #               plotOutput("cellgroupWiseGeneExp"))
      # )
    )
  )
))
