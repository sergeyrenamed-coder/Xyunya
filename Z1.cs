using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace Lab3
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void ColorMenu_Click(object sender, RoutedEventArgs e)
        {
            string tag = ((FrameworkElement)sender).Tag.ToString();
            if (tag == "red")   MainGrid.Background = Brushes.Red;
            if (tag == "green") MainGrid.Background = Brushes.Green;
            if (tag == "blue")  MainGrid.Background = Brushes.Blue;
        }

        private void About_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Разработчик: Иванов И.И.\nГруппа: ПИ-101",
                            "О разработчике");
        }

        private void Close_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void MenuItem_MouseEnter(object sender, MouseEventArgs e)
        {
            string tag = ((FrameworkElement)sender).Tag?.ToString() ?? "";
            StatusText.Text = tag;
        }

        private void Menu_MouseEnter(object sender, MouseEventArgs e)
        {
            StatusText.Text = "Меню: Цвет фона";
        }
    }
}
