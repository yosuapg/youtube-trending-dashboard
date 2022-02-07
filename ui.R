######################
####   Shiny ui   ####
######################

library(shinyWidgets)
library(shiny)
library(shinyWidgets)
library(shiny)
library(plotly)
library(shinythemes)
library(DT)
library(rsconnect)

# ------------------
# Main title section
# ------------------

ui <- navbarPage(
  "Youtube Trend Analytics Nov 2017 - Jan 2018",
  theme = shinytheme("flatly"),
  tabPanel(
    "Main",
    # App title ----
    titlePanel(div(
      windowTitle = "YoutubeTrend",
      img(src = "yt0.png", width = "100%", class = "bg"),
    )),
    
    tags$br(),
    
    ##############################
    ####  Panel: Main>Summary ####
    ##############################
    
    tabsetPanel(
      type = "tabs",
      tabPanel(
        "Summary",
        
        # --------------------
        # Bar plot section
        # --------------------
        
        sidebarLayout(
          sidebarPanel(
            h3("Category Panel"),
            tags$br(),
            
            checkboxGroupInput(
              "checkCategory",
              label = "Select University",
              choices = list(
                "Travel and Events" = "Travel and Events",
                "Sports" = "Sports",
                "Science and Technology" = "Science and Technology",
                "Pets and Animals" = "Pets and Animals",
                "People and Blogs" = "People and Blogs",
                "News and Politics" = "News and Politics",
                "Music" = "Music",
                "Howto and Style" = "Howto and Style",
                "Gaming" = "Gaming",
                "Film and Animation" = "Film and Animation",
                "Entertainment" = "Entertainment",
                "Education" = "Education",
                "Comedy" = "Comedy",
                "Autos and Vehicles" = "Autos and Vehicles"
              ),
              selected = list(
                "Travel and Events" = "Travel and Events",
                "Sports" = "Sports",
                "Science and Technology" = "Science and Technology",
                "Pets and Animals" = "Pets and Animals",
                "People and Blogs" = "People and Blogs",
                "News and Politics" = "News and Politics",
                "Music" = "Music",
                "Howto and Style" = "Howto and Style",
                "Gaming" = "Gaming",
                "Film and Animation" = "Film and Animation",
                "Entertainment" = "Entertainment",
                "Education" = "Education",
                "Comedy" = "Comedy",
                "Autos and Vehicles" = "Autos and Vehicles"
              )
            ),
          ),
          
          
          
          mainPanel(
            tabsetPanel(
              type = "tabs",
              tags$br(),
              tabPanel("Top 10 Youtube Channel", plotlyOutput(outputId = "barPlot")),
              tabPanel("Likes vs Dislikes Ratio", plotlyOutput(outputId = "scatterPlot"))
            )
          )
        )
      ),
    
    ########################################################
    #### Panel: Main>Daily Breakdown>Tables & Point Chart ####
    ########################################################
    
    tabPanel(
      "Daily Breakdown",
      
      # ------------------
      # ranking $ point chart section
      # ------------------
      
      sidebarLayout(
        sidebarPanel(
          h3("Data by Date"),
          tags$br(),
          dateInput(
            "checkDate",
            "Select Date",
            value = "2017-11-14",
            min = "2017-11-14",
            max = "2018-01-20",
            format = "yyyy-mm-dd",
          )
        ),
        
        mainPanel(
          tabsetPanel(
            type = "tabs",
            tags$br(),
            tabPanel("Ranking", dataTableOutput("datahead")),
            tabPanel("No. of Category", plotlyOutput(outputId = "pointPlot"))
          ),
          tags$br(),
          tags$br(),
        )
      ),
      tags$hr()
      ),
    
    ###############################
    ####  Panel: Main>Database ####
    ###############################
    
    tabPanel(
      "Database",
      tags$br(),
      dataTableOutput("database")
      )
    )),
  
  ##############################
  #### Panel: About ####
  ##############################
  
  tabPanel("About",
           fluidPage(htmlOutput("about")))
  )