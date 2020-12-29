# RadioGroupContainer
RadioGroupContainer for iOS

It's a container for radio button feature.

![RadioGroupContainer](https://user-images.githubusercontent.com/13866671/103258540-c57d0300-49d8-11eb-82fb-d9fa46ee5428.gif)

## Requirements
* iOS 9.0+
* Swift 5.0+

## Indstallation
### Build
1. build scheme을 UniversalRadioGroupContainer으로 맞추고 빌드 타겟을 Any iOS Device로 맞춘 후 빌드하면, build 폴더가 프로젝트 경로에 생성됩니다.
build폴더의 RadioGroupContainer.framework를 프로젝트에 추가하시면 됩니다.
2. Frameworks, Libraries, and Embedded Content에 RadioGroupContainer.framework가 추가 되었으면, Embed & Sign으로 바꿔주시면 빌드가 됩니다.

### Manually
파일을 직접 프로젝트에 복사하여 사용하실 수 있습니다.

## Usage
### Quick Start
```swift
import RadioGroupContainer

enum TestEnum: String {
    case wow1
    case wow2
}

class ViewController: UIViewController, RadioGroupContainerDelegate {
    let radioButtonGroup = RadioGroupContainer<TestEnum>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton(type: .custom)
        button1.setTitleColor(.systemBlue, for: .normal)
        button1.setTitleColor(.systemGray, for: .selected)
        ...
        let button2 = UIButton(type: .custom)
        button2.setTitleColor(.systemBlue, for: .normal)
        button2.setTitleColor(.systemGray, for: .selected)
        ...
        
        radioButtonGroup.add((button: button1, key: .wow1))
        radioButtonGroup.add((button: button2, key: .wow2))
        radioButtonGroup.delegate = self
    }
    
    func onTouchUpInsideRadioButton<T>(_ sender: (button: UIButton, key: T)) where T : Equatable {
        // 선택된 라디오 버튼의 터치 이벤트
    }
}
```

## License

```
Copyright 2020-present NAVER Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
