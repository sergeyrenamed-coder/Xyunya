using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;

namespace Lab3Task2
{
    public partial class MainWindow : Window
    {
        private bool isDrawing = false;
        private Brush currentBrush = Brushes.Black;
        private double brushSize = 10;

        public MainWindow()
        {
            InitializeComponent();
            SizeSlider.ValueChanged += (s, e) =>
            {
                brushSize = SizeSlider.Value;
                if (SizeLabel != null)
                    SizeLabel.Content = ((int)brushSize).ToString();
            };
        }

        private void ColorComboBox_SelectionChanged(object sender,
            SelectionChangedEventArgs e)
        {
            var item = ColorComboBox.SelectedItem as ComboBoxItem;
            if (item == null) return;
            string tag = item.Tag.ToString();
            currentBrush = tag switch
            {
                "Red"   => Brushes.Red,
                "Green" => Brushes.Green,
                "Blue"  => Brushes.Blue,
                _       => Brushes.Black
            };
        }

        private void Canvas_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (DrawRadio.IsChecked == true)
                isDrawing = true;
        }

        private void Canvas_MouseMove(object sender, MouseEventArgs e)
        {
            if (!isDrawing) return;
            if (DrawRadio.IsChecked != true) return;

            var pos = e.GetPosition(DrawCanvas);
            var ellipse = new Ellipse
            {
                Width  = brushSize,
                Height = brushSize,
                Fill   = currentBrush
            };
            Canvas.SetLeft(ellipse, pos.X - brushSize / 2);
            Canvas.SetTop(ellipse,  pos.Y - brushSize / 2);
            DrawCanvas.Children.Add(ellipse);
        }

        protected override void OnMouseUp(MouseButtonEventArgs e)
        {
            base.OnMouseUp(e);
            isDrawing = false;
        }
    }
}
