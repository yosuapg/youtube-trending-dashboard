##########################################
####   Main Libraries                 ####
##########################################
library(shiny)
library(dplyr)
library(tidyr)
library(DT)
library(glue)
library(ggplot2)
library(ggthemes)
library(plotly)

library(rsconnect)
library(shinythemes)

##########################################
####   Attaching datasets             ####
##########################################

# Read data .csv
df <- read.csv("data/youtube.csv")

## Change string to Date
df$Trending.Date <- as.Date(df$Trending.Date, "%m/%d/%Y")


##########################################
####   Shiny server                   ####
##########################################

server <- function(session, input, output) {
  
  #############################
  #### Panel: Main>Summary ####
  #############################
  
  # ----------------
  # bar plot section
  # ----------------
  
  output$barPlot <- renderPlotly({
    bar_data <- df %>% 
      filter(Category %in% input$checkCategory) %>% 
      group_by(Channel.Title) %>% 
      summarise(Likes.Ratio = mean(Likes/Views)) %>% 
      arrange(desc(Likes.Ratio)) %>% 
      head(10)
    
    bar <- ggplot(data = bar_data, aes(x = Likes.Ratio, 
                                       y = reorder(Channel.Title, Likes.Ratio),
                                       text = glue("Likes ratio: {round(Likes.Ratio,2)}")))+ 
      geom_col(aes(fill = Likes.Ratio), show.legend = F)+
      scale_fill_gradient(low = "#fff2cd", high = "firebrick")+
      theme_minimal() +
      theme(panel.grid.major.x = element_blank(),
            panel.grid.major.y = element_blank(),
            axis.title.y = element_blank(),
            axis.title.x = element_blank())
    
    ggplotly(bar, tooltip = "text")
    
  })
  
  # ----------------
  # scatter plot section
  # ----------------
  
  output$scatterPlot <- renderPlotly({
    scatter_data <- df %>% 
      filter(Category %in% input$checkCategory) %>% 
      group_by(Channel.Title) %>% 
      summarise(Likes.Ratio = mean(Likes/Views), Dislikes.Ratio = mean((Dislikes)/Views)) %>% 
      arrange(desc(Likes.Ratio))
    
    scatter <- ggplot(data = scatter_data, aes(x = Likes.Ratio,
                                               y = Dislikes.Ratio,
                                               text = glue("Likes ratio: {round(Likes.Ratio,2)}, 
                                                           Dislikes ratio: {round(Dislikes.Ratio,2)}")))+ 
      geom_point(aes(size = 0.5, alpha = 0.1, color = "firebrick"), show.legend = F)+
      labs(y = "Dislikes Ratio", x = "Likes Ratio", 
           subtitle = "Measured by Likes Ratio")+
      theme_minimal()
    
    scatter <- scatter + theme(legend.position = "none")
    
    ggplotly(scatter, tooltip = "text")
    
  })
  
  ########################################################
  #### Panel: Main>Daily Breakdown>Tables & Point Chart ####
  ########################################################
  
  # ----------------
  # Ranking section
  # ----------------
  
  output$datahead <- renderDataTable({
    df %>%
      filter(Trending.Date == input$checkDate) %>%
      group_by(Channel.Title) %>% 
      summarise(Percentage.Likes.Ratio = round(mean(Likes/Views)*100,2),
                Percentage.Dislikes.Ratio = round(mean(Dislikes/Views)*100,2)) %>% 
      arrange(desc(Percentage.Likes.Ratio))
  })
  
  # ----------------
  # point plot section
  # ----------------
  
  output$pointPlot <- renderPlotly({
    point_data <- df %>% 
      filter(Trending.Date == input$checkDate) %>%
      group_by(Category) %>%
      summarise(Count = length(Category))
    
    point <- ggplot(point_data, aes(x=Category, y=Count, 
                                text = glue("Video count: {Count}"))) +
      geom_segment( aes(x=Category, xend=Category, y=0, yend=Count), color="pink") +
      geom_point( color="red", size=4, alpha=0.6) +
      theme_light() +
      coord_flip() +
      theme(
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_blank()
      )
    
    ggplotly(point, tooltip = "text")
    
  })
  
  ##############################
  #### Panel: Main>Database ####
  ##############################
  
  # ----------------
  # Table section
  # ----------------
  
  output$database <- renderDataTable({
    df 
  })
  
  
  #######################
  #### Panel: About  ####
  #######################
  
  getPageAbout <- function() {
    return(includeHTML("about.html"))
  }
  output$about <- renderUI({
    getPageAbout()
  })
}


  