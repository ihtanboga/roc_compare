# ROC Curve Comparison (DeLong Test)

This R Shiny application allows for the statistical comparison of two Receiver Operating Characteristic (ROC) curves using the DeLong test. It provides a user-friendly interface for researchers and practitioners in fields such as medicine, bioinformatics, and machine learning to assess the performance of diagnostic tests or predictive models.

## Features

*   **Interactive Upload:** Easily upload your data in CSV format.
*   *   **DeLong Test:** Perform a rigorous statistical comparison of two ROC curves.
    *   *   **Visualizations:** Generate high-quality ROC plots with confidence intervals.
        *   *   **Performance Metrics:** Obtain key metrics such as AUC, sensitivity, specificity, and their confidence intervals.
         
            *   ## Installation and Usage
         
            *   To run this application locally, you need to have R and RStudio installed, along with the following R packages:
         
            *   ```R
                install.packages(c("shiny", "pROC", "DT", "ggplot2"))
                ```

                Once the packages are installed, you can run the application using the `app.R` file:

                ```R
                shiny::runApp("path/to/your/app.R")
                ```

                ## Data Format

                Your input CSV file should contain at least two columns:

                1.  **`outcome`**: Binary outcome variable (e.g., 0 for control, 1 for disease).
                2.  2.  **`marker1`**: Continuous or ordinal values for the first diagnostic marker/model.
                    3.  3.  **`marker2`**: Continuous or ordinal values for the second diagnostic marker/model.
                      
                        4.  ## Example
                      
                        5.  An example dataset is provided within the application for demonstration purposes.
                      
                        6.  ## Contributing
                      
                        7.  Contributions are welcome! Please feel free to open an issue or submit a pull request.
                      
                        8.  ## License
                      
                        9.  This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
                        10.  
