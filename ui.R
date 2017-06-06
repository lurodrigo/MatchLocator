
dashboardPage(
  dashboardHeader(title = "Match Locator"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      column(width = 12,
        box(title = "Mapa", width = NULL,
          leafletOutput("mapa", height = 600),
          solidHeader = TRUE, status = "primary"
        )
      )
    )
  )
)