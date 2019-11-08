#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

#load data from Arctic Data Cnter
data_url <- "https://arcticdata.io/metacat/d1/mn/v2/object/urn%3Auuid%3A35ad7624-b159-4e29-a700-0c0770419941"
bg_chem <- read.csv(url(data_url, method = "libcurl"), stringsAsFactors = FALSE)
nameBG = names(bg_chem)



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Biogeochemistry"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("xlimits",
                        "x axis limits:",
                        min = 0,
                        max = 500,
                        value = c(1,50)),
            selectInput("col",
                        "color variation",
                        choices = nameBG[11:16],
                        selected = "Si"),
            selectInput("yaxis",
                        "Y axis variable",
                        choices = nameBG[8:16],
                        selected = "CTD_Salinity")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           plotOutput("secondPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # Let's make a scatter plot!
        ggplot(bg_chem, aes_string(x = "CTD_Depth", y = input$yaxis, color = input$col)) +
            geom_point(size = 10) +
            scale_x_continuous(limits = c(input$xlimits))+
            ylab(paste(names(bg_chem)[which(input$yaxis == nameBG)]))+
            scale_color_continuous(name = paste(names(bg_chem)[which(input$col == nameBG)]))+
            theme_light()
        
    })
    
    output$secondPlot <- renderPlot({
        # Let's make a scatter plot!
        ggplot(bg_chem, aes(x = Date, y = CTD_Salinity, color = bg_chem[,input$col])) +
            geom_point(size = 10) +
            scale_y_continuous(limits = c(input$ylimits))+
            scale_color_continuous(name = paste(names(bg_chem)[which(input$col == nameBG)]))+
            theme_light()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
