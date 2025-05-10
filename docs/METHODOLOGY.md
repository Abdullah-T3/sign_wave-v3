# CHAPTER IV: METHODOLOGY

## 4.1 Methodology

### 4.1.1 Agile Development Approach

The Sign Wave project follows an agile development methodology to ensure flexibility, continuous improvement, and user-centered design. The agile approach includes:

- **Scrum Framework**: Two-week sprint cycles with daily stand-up meetings
- **User Stories**: Requirements captured as user stories with acceptance criteria
- **Iterative Development**: Incremental feature implementation with regular feedback loops
- **Continuous Integration**: Automated testing and deployment pipeline
- **Sprint Reviews**: Demonstrations of completed features to stakeholders
- **Retrospectives**: Team reflection and process improvement after each sprint

### 4.1.2 Machine Learning Model Development

The sign language recognition component follows a structured machine learning development process:

- **Dataset Collection**: 
  - Compilation of ASL video samples from public datasets
  - Recording of additional signs with diverse signers (age, gender, ethnicity)
  - Data augmentation techniques to increase sample diversity

- **Data Preprocessing**:
  - Frame extraction and normalization
  - Hand and body keypoint detection using MediaPipe
  - Feature extraction and representation

- **Model Architecture**:
  - CNN-LSTM hybrid model for temporal sequence recognition
  - Transfer learning from pre-trained models
  - Model quantization for mobile deployment

- **Training Process**:
  - 80/10/10 split for training, validation, and testing
  - Hyperparameter optimization
  - Cross-validation for robustness

- **Evaluation Metrics**:
  - Recognition accuracy
  - Inference time
  - Confusion matrix analysis
  - Real-world testing with deaf users

### 4.1.3 User-Centered Design Process

The design process prioritizes the needs of both deaf and hearing users:

- **User Research**:
  - Interviews with 15 deaf individuals and 10 hearing individuals
  - Contextual inquiry observing current communication methods
  - Survey of 50+ potential users regarding communication challenges

- **Persona Development**:
  - Creation of 4 primary user personas representing different user groups
  - Scenario mapping for key use cases

- **Iterative Design**:
  - Low-fidelity wireframes
  - Interactive prototypes
  - Usability testing with representative users
  - Design refinement based on feedback

- **Accessibility Considerations**:
  - Color contrast compliance
  - Screen reader compatibility
  - Alternative input methods
  - Customizable interface elements

### 4.1.4 Testing Methodology

Comprehensive testing ensures application quality and reliability:

- **Unit Testing**:
  - Testing individual components in isolation
  - Mock objects for external dependencies
  - Coverage targets of 80%+ for critical modules

- **Integration Testing**:
  - Testing component interactions
  - API contract validation
  - End-to-end workflow testing

- **User Acceptance Testing**:
  - Structured testing sessions with deaf and hearing users
  - Task completion metrics
  - Satisfaction surveys
  - Accessibility compliance verification

- **Performance Testing**:
  - Response time measurement
  - Resource utilization monitoring
  - Battery consumption analysis
  - Stress testing under various network conditions

## 4.2 Used Tools

### 4.2.1 Development Tools

- **Flutter (v2.10+)**:
  - Cross-platform UI toolkit
  - Widget-based reactive programming model
  - Hot reload for rapid development

- **Dart (v2.16+)**:
  - Programming language optimized for Flutter
  - Strong typing and null safety
  - Asynchronous programming support

- **Firebase**:
  - Authentication for user management
  - Cloud Firestore for database
  - Cloud Functions for serverless backend logic
  - Cloud Storage for media files
  - Crashlytics for error reporting

- **TensorFlow Lite (v2.8+)**:
  - On-device machine learning inference
  - Model optimization for mobile deployment
  - GPU delegation for performance

- **ZegoCloud SDK**:
  - Real-time video communication
  - Low-latency streaming
  - Call quality optimization

- **Git & GitHub**:
  - Version control
  - Collaborative development
  - CI/CD pipeline integration

### 4.2.2 Design Tools

- **Figma**:
  - UI/UX design
  - Collaborative design environment
  - Interactive prototyping
  - Design system management

- **Adobe XD**:
  - Alternative prototyping tool
  - User flow visualization
  - Design asset creation

- **Material Design Components**:
  - Consistent UI elements
  - Accessibility-compliant components
  - Responsive layout patterns

### 4.2.3 Testing Tools

- **Flutter Test**:
  - Widget testing framework
  - Integration test support
  - Golden image testing

- **Firebase Test Lab**:
  - Device farm for testing
  - Automated UI testing
  - Performance monitoring

- **Lighthouse**:
  - Accessibility testing
  - Performance metrics
  - Best practices validation

### 4.2.4 Project Management Tools

- **Jira**:
  - Agile project management
  - Sprint planning
  - Issue tracking

- **Confluence**:
  - Documentation platform
  - Knowledge sharing
  - Requirements management

- **Slack**:
  - Team communication
  - Integration with development tools
  - File sharing and collaboration

## 4.3 Hardware

### 4.3.1 Development Hardware

- **Development Workstations**:
  - MacBook Pro (M1, 16GB RAM) for iOS development
  - Windows workstations (i7, 32GB RAM) for Android development
  - External monitors for expanded workspace

- **Mobile Device Testing Suite**:
  - iPhone 12, 13 (iOS 15+)
  - Samsung Galaxy S21, S22 (Android 12+)
  - Google Pixel 5, 6 (Android 12+)
  - Older devices for compatibility testing

- **Camera Equipment**:
  - High-definition webcams for development testing
  - Lighting equipment for controlled testing environments
  - Green screens for background isolation testing

### 4.3.2 Deployment Requirements

- **Minimum Device Specifications**:
  - iOS 14+ or Android 10+
  - 3GB RAM minimum
  - 64-bit processor
  - Camera with minimum 720p resolution
  - 100MB free storage space

- **Recommended Specifications**:
  - iOS 15+ or Android 12+
  - 4GB+ RAM
  - Camera with 1080p resolution
  - Processor with AI acceleration capabilities
  - 500MB+ free storage space

### 4.3.3 Server Infrastructure

- **Cloud Services**:
  - Google Cloud Platform for backend services
  - Firebase project configuration
  - Scalable instance sizing based on user load

- **Database Configuration**:
  - Cloud Firestore in native mode
  - Appropriate indexing for query performance
  - Backup and disaster recovery setup

- **API Gateway**:
  - Cloud Functions for Firebase
  - RESTful API design
  - Authentication middleware
  - Rate limiting and security measures