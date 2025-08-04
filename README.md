# iTunes-SearchApp

iTunes Store의 다양한 콘텐츠(영화, 음악, 팟캐스트)를 검색하고 확인할 수 있습니다.

## 🌟 주요 특징

이 프로젝트는 유지보수 및 확장이 용이한 클린 아키텍처(Clean Architecture)를 기반으로 설계되었습니다.

### 아키텍처 (Architecture)

**계층형 구조 (Layered Architecture)**

코드를 세 가지 명확한 책임 계층으로 분리하여 관심사를 분리(Separation of Concerns)하고 코드의 응집도를 높였습니다.

- **Presentation Layer**: UI와 관련된 모든 로직을 처리합니다.
  - **MVVM (Model-View-ViewModel)** 패턴을 적용하여 UI 로직(View)과 상태(ViewModel)를 분리했습니다.
  - `HomeViewController`, `SearchViewController` 등이 사용자와의 상호작용을 담당합니다.
- **Domain Layer**: 앱의 핵심 비즈니스 로직을 포함합니다.
  - **Use Cases**: `SearchUseCase`와 같이 특정 비즈니스 로직을 캡슐화합니다.
  - **Entities**: `Movie`, `Music` 등 순수한 데이터 모델을 정의합니다.
  - **Repository Interfaces**: `MovieRepository`와 같이 데이터 소스에 대한 추상화된 인터페이스를 제공하여 데이터 계층과의 의존성을 낮춥니다.
- **Data Layer**: 데이터 소스와의 상호작용을 담당합니다.
  - **Repository Implementations**: `MovieRepositoryImpl`과 같이 Domain 계층의 인터페이스를 실제로 구현합니다.
  - **Network**: `APIService`를 통해 iTunes API와 통신합니다.

### 1. 의존성 주입 (Dependency Injection)

`DIContainer`를 사용하여 앱 전체의 의존성을 관리합니다. 각 컴포넌트는 생성 시점에서 필요한 의존성을 외부로부터 주입받아 다음과 같은 장점을 가집니다.

- **느슨한 결합 (Loose Coupling)**: 컴포넌트 간의 의존성이 낮아져 코드 수정 및 교체가 용이합니다.
- **테스트 용이성 (Testability)**: 실제 객체 대신 Mock 객체를 쉽게 주입하여 단위 테스트를 효과적으로 작성할 수 있습니다.

### 2. 추상화 (Abstraction)
 
Domain 계층에 Repository 인터페이스를 정의함으로써, 비즈니스 로직이 실제 데이터 구현(네트워크, 데이터베이스 등)에 대해 알 필요가 없도록 설계했습니다. 이를 통해 다음과 같은 이점을 얻습니다.

- **유연성**: 나중에 데이터 소스를 변경하거나 추가하더라도(예: 네트워크 API를 로컬 DB로 교체), Domain 계층의 코드 수정 없이 Data 계층만 수정하면 됩니다.
- **관심사 분리**: 비즈니스 로직과 데이터 접근 로직이 명확하게 분리됩니다.

### 3. 모듈화 (Modularity)
- 프로젝트가 `Data`, `Domain`, `Presentation` 이라는 명확한 3개의 레이어로 나뉘어 있습니다. 각 레이어는 특정한 책임(데이터 처리, 비즈니스 로직, UI)을 가지며, 이는 코드의 관심사를 분리하여 유지보수와 확장을 용이하게 만듭니다. 예를 들어, 나중에 **네트워크 라이브러리를 바꾸고싶다면** `Data` 레이어만 수정하면 되고, **UI를 변경하고 싶다면** `Presentation` 레이어에 집중할 수 있습니다.

### 4. 사용성 UX(User Experience)
- 검색 결과 없을 경우 화면에 검색 결과 없음으로 표시


### 5. 메모리 이슈 
 - 메모리 누수 이슈는 발견 되지 않았습니다.
 - Product -> scheme -> edit schemeRun -> Digonostics -> Malloc Stack Loging
 - Profile -> info ->Build Configuration -> Debug -> cmd + i 로  빌드하여 기능 확인하면서 메모리 누수 체크

<img width="1396" height="907" alt="스크린샷 2025-08-04 17 05 16" src="https://github.com/user-attachments/assets/0def7e99-b715-47a3-a770-56f723cd606c" />

### 스크린샷

![Simulator Screen Recording - iPhone 16 Pro - 2025-08-04 at 17 06 16](https://github.com/user-attachments/assets/2113292d-208e-407d-a462-549dc438d0f3)
