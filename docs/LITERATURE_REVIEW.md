# CHAPTER II: LITERATURE REVIEW

## 2.1 Literature Review

This chapter presents a comprehensive review of existing research, technologies, and applications related to sign language recognition and translation systems. The literature review establishes the theoretical foundation for the Sign Wave application and identifies gaps in current solutions that this project aims to address.

### 2.1.1 Sign Language Recognition Technologies

#### Computer Vision Approaches

Early sign language recognition systems relied primarily on computer vision techniques without deep learning. Starner et al. (1998) pioneered work using hidden Markov models (HMMs) to recognize a vocabulary of 40 ASL signs with accuracy rates of 92-98% under controlled conditions. However, these systems required controlled backgrounds and specific camera angles, limiting their practical application.

More recent computer vision approaches incorporate feature extraction methods such as Scale-Invariant Feature Transform (SIFT) and Histogram of Oriented Gradients (HOG). Cooper et al. (2012) demonstrated that these techniques could achieve recognition rates of up to 76% for isolated signs in natural environments, representing a significant improvement in robustness.

#### Deep Learning Methods

The application of deep learning has revolutionized sign language recognition. Convolutional Neural Networks (CNNs) have proven particularly effective for image-based sign recognition. Koller et al. (2016) achieved 91.7% accuracy on a large-scale German Sign Language dataset using CNN architectures.

For continuous sign language recognition, recurrent neural networks (RNNs) and Long Short-Term Memory (LSTM) networks have shown promising results. Camgoz et al. (2018) introduced a neural network architecture combining CNNs with bidirectional LSTMs, achieving state-of-the-art performance on continuous sign language recognition tasks.

#### Sensor-Based Approaches

Alternative approaches utilize specialized hardware such as depth sensors, data gloves, or electromyography (EMG) sensors. Cheng et al. (2015) demonstrated 95% accuracy using Microsoft Kinect depth sensors for a vocabulary of 100 signs. While these approaches often achieve higher accuracy, they require specialized equipment that limits widespread adoption.

### 2.1.2 Mobile Applications for Sign Language Translation

Several mobile applications have attempted to address the communication gap between deaf and hearing individuals:

#### Hand Talk (2012)

Hand Talk translates text and voice to Brazilian Sign Language (Libras) using a 3D avatar. While innovative, it focuses only on one-way translation (spoken/written language to sign language) and does not provide sign-to-text capabilities.

#### SignAll (2016)

SignAll uses computer vision with multiple cameras and special gloves to translate ASL. The system achieves high accuracy but requires a controlled environment and specialized equipment, making it impractical for everyday mobile use.

#### Google's SignIt (2018)

Google's experimental application uses machine learning to recognize a limited set of ASL signs through a smartphone camera. While promising, it has a limited vocabulary and struggles with continuous signing in varied lighting conditions.

### 2.1.3 Speech-to-Text Technologies for Deaf Users

Speech recognition technologies have advanced significantly, with systems like Google's Speech-to-Text API achieving word error rates below 5% for English in ideal conditions. However, challenges remain in noisy environments, with accented speech, and with technical terminology.

Applications like Live Transcribe and Otter.ai provide real-time transcription for deaf users but do not integrate with sign language recognition for two-way communication.

### 2.1.4 Video Communication Platforms for Deaf Users

Existing video communication platforms like Zoom and Microsoft Teams have added closed captioning features, but these are often inaccurate and do not support sign language interpretation. Specialized platforms like Purple Communications provide human sign language interpreters for video calls, but these services are expensive and not always available.

### 2.1.5 Gaps in Existing Solutions

The literature review reveals several gaps in existing solutions:

1. **Integration Gap**: Most applications focus on either sign-to-text or text-to-sign translation, but few provide seamless two-way communication.

2. **Mobility Constraints**: High-accuracy systems often require specialized equipment or controlled environments, limiting practical everyday use.

3. **Vocabulary Limitations**: Many mobile applications support only a limited vocabulary of signs, restricting their usefulness in real-world conversations.

4. **User Experience Issues**: Technical solutions often neglect the user experience needs of both deaf and hearing users, creating barriers to adoption.

5. **Video Communication Integration**: Few solutions effectively integrate sign language translation with video calling capabilities.

### 2.1.6 Theoretical Framework

Based on the literature review, Sign Wave adopts a theoretical framework that combines:

1. **User-Centered Design**: Prioritizing the needs and experiences of both deaf and hearing users throughout the development process.

2. **Multimodal Communication Theory**: Recognizing that effective communication involves multiple channels and modes of expression.

3. **Assistive Technology Acceptance Model**: Understanding the factors that influence adoption of assistive technologies among target users.

4. **Universal Design Principles**: Creating an application that is accessible and usable by people with the widest possible range of abilities.

### 2.1.7 Conclusion

The literature review demonstrates significant advances in sign language recognition technologies, particularly with the application of deep learning methods. However, existing mobile applications have not yet successfully combined accurate sign language recognition, speech-to-text conversion, and video calling in a user-friendly package suitable for everyday use.

Sign Wave aims to address these gaps by developing an integrated mobile application that leverages state-of-the-art machine learning techniques while prioritizing usability, accessibility, and practical functionality for both deaf and hearing users.

### References

1. Starner, T., Weaver, J., & Pentland, A. (1998). Real-time American sign language recognition using desk and wearable computer based video. IEEE Transactions on Pattern Analysis and Machine Intelligence, 20(12), 1371-1375.

2. Cooper, H., Holt, B., & Bowden, R. (2012). Sign language recognition. In Visual Analysis of Humans (pp. 539-562). Springer, London.

3. Koller, O., Ney, H., & Bowden, R. (2016). Deep hand: How to train a CNN on 1 million hand images when your data is continuous and weakly labelled. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (pp. 3793-3802).

4. Camgoz, N. C., Hadfield, S., Koller, O., & Bowden, R. (2018). Neural sign language translation. In Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (pp. 7784-7793).

5. Cheng, H., Yang, L., & Liu, Z. (2015). Survey on 3D hand gesture recognition. IEEE Transactions on Circuits and Systems for Video Technology, 26(9), 1659-1673.