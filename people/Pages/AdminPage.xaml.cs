using people.AppData;
using System.Windows;
using System.Windows.Controls;

namespace people.Pages
{
    /// <summary>
    /// Логика взаимодействия для AdminPage.xaml
    /// </summary>
    public partial class AdminPage : Page
    {
        public AdminPage()
        {
            InitializeComponent();
        }

        private void ProductsButton_Click(object sender, RoutedEventArgs e)
        {
            AdminContentFrame.Navigate(new PeopleAdminPage(null));
        }

        private void CategoriesButton_Click(object sender, RoutedEventArgs e)
        {
            AdminContentFrame.Navigate(new CategoriesAdminPage());
        }

        private void OrdersButton_Click(object sender, RoutedEventArgs e)
        {
            AdminContentFrame.Navigate(new OrdersAdminPage());
        }

        private void UsersButton_Click(object sender, RoutedEventArgs e)
        {
            AdminContentFrame.Navigate(new UsersAdminPage());
        }

        private void CitiesButton_Click(object sender, RoutedEventArgs e)
        {
            AdminContentFrame.Navigate(new CitiesAdminPage());
        }

        private void GoToCatalogButton_Click(object sender, RoutedEventArgs e)
        {
            AppFrame.framemain.Navigate(new PeopleCatalogPage());
        }
    }
}


