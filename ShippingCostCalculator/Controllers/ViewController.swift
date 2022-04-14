//
//  ViewController.swift
//  ShippingCostCalculator
//
//  Created by Максим Беседин on 07.03.2022.
//

import UIKit

class CalculatingViewController: UIViewController {
    
    //Здесь будет храниться результат расчета суммы заказа для отображения в финальном Label
    var cdekValue = "0.0"
    var distance : Double?
    // дефолтная цена за параметр объекта
    var defaultParamPrice: Int = 200
    
    var paramPriceMatrix: [Array<Double>: Int] = [[0, 1]: 0,
                                                  [2, 5]: 10,
                                                  [5, 10]: 15,
                                                  [10, 15]: 20,
                                                  [15, 20]: 25,
                                                  [20, 25]: 30,
                                                  [25, 35]: 35,
                                                  [35, 45]: 40,
                                                  [45, 60]: 45,
                                                  [60, 75]: 50,
                                                  [75, 90]: 55,
                                                  [90, 110]: 60,
                                                  [110, 130]: 65,
                                                  [130, 150]: 70,
                                                  [150, 200]: 90,]
    
    let weightArray : [String] = [
        "До 2 кг",
        "До 5 кг",
        "До 12 кг",
        "До 20 кг",
        "До 50 кг",
        "До 199 кг",
     
    ]
    //Здесь будет храниться выбор пользователя в pickerView
    var pickerValue = ""
    
    //Добавляем аутлеты для view
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet var mainView: UIView!
    
    //Добавляем аутлеты для slider
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var lengthSlider: UISlider!
    
    //Добавляем аутлеты для label
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    //Добавляем  outlet для picker
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picker = pickerOutlet
        
        //Подписываемся на протокол dataSource (Пока не знаю что это, надо изучить)
        picker?.dataSource = self
        
        picker?.delegate = self
        
        //Задаем закгругление у whiteView
        whiteView?.layer.cornerRadius = 30
        
        //Скрываем нижние закругленные края у whiteView
        whiteView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    // Добавляем  action для слайдера с шириной
    @IBAction func heightValue(_ sender: UISlider) {
        heightLabel.text = String(format: "%.1f", sender.value) + String(" см")
    }
    // Добавляем  action для слайдера с высотой
    @IBAction func widthValue(_ sender: UISlider) {
        widthLabel.text = String(format: "%.1f", sender.value) + String(" см")
    }
    // Добавляем  action для слайдера с длиной
    @IBAction func lengthValueFunction(_ sender: UISlider) {
        lengthLabel.text = String(format: "%.1f", sender.value) + String(" см")
    }
    
    // Добавляем  action для кнопки расчета стоимости доставки
    @IBAction func calculateButton(_ sender: UIButton) {
    //Переменные в которых будут храниться значения слайдеров
        let height = heightSlider.value
        let width = widthSlider.value
        let length = lengthSlider.value
    
    //Переменная в которую мы записываем результат расчетов по стоимости доставки
        var cdek : Float
        
    //Вместо привычного if будем использовать switch, так как вариантов много и каждый нужно проверить
        switch pickerValue {
        case "До 2 кг" : cdek = (height * width * length + 250) / 100
        case "До 5 кг" : cdek = (height * width * length + 400) / 100
        case "До 12 кг" : cdek = (height * width * length + 600) / 100
        case "До 20 кг" : cdek = (height * width * length + 850) / 100
        case "До 50 кг" : cdek = (height * width * length + 1500) / 100
        case "До 199 кг" : cdek = (height * width * length + 200) / 100
        default: cdek = 0.0
        }
        print(distance)
        cdekValue = String(format: "%.1f", cdek) + String(" рублей")
        
        print (cdekValue)
        //Переход на mapViewController
        self.performSegue(withIdentifier: "goToResult", sender: self)
        
//      self.performSegue(withIdentifier: "goToMap", sender: self) //goToResult
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationView = segue.destination as! ResultViewController
            destinationView.result = cdekValue
        }
    }
    
}

extension CalculatingViewController: UIPickerViewDataSource {
    
    //Сколько компонентов выводить в пикер
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Сколько строк в компоненте в пикере
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
}

extension CalculatingViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Фиксируем выбор пользователя в переменную pickerValue
        pickerValue = weightArray[row]
        
        return weightArray[row]
            
            }
}

 
