nafsi
Monitoring stress and eating habits: early warning signs and support through Apple Watch, iPhone Health and AI

Senior Design Group: Noorah Alshamsi, Mariam Mohammed Binsuwaif, Hend Abdellatif
Supervisor: Ibrahim Abaker Hashem | Mentor: Manar Abu Talib
Examination Committee: Prof. Ashraf Elnagar, Dr. Huseyin Kusetogullari, Dr. Isam Al Jawarneh
College of Computing and Informatics, Department of Computer Science, University of Sharjah

Problem statement
The reason behind nafsi

We studied anxiety and eating disorders for our senior project and found a strong connection between them. Stress often changes how people eat. Some people stop eating meals, some eat too much, and others start to tightly control their food.

These signs are usually noticed too late. Students in the UAE also have no single, easy tool that looks at both problems at once and guides them to help early on.

Technical background

	•	GAD-7 (Spitzer et al., 2006): a seven-question survey that screens for anxiety.
	•	EDE-Q (Fairburn & Beglin, 1994): a questionnaire about eating behavior over the past 28 days.
	•	Heart rate variability (HRV) goes down when a person is stressed. Read alongside resting heart rate, sleep and breathing rate, it gives an idea of stress levels (Kim et al., 2018).
	•	Apple HealthKit keeps data from the Apple Watch and iPhone. The app can read it once the user allows it.
	•	Large language models like Google Gemini can turn a user's answers into a short summary in everyday language.
	•	The Mifflin-St Jeor equation estimates how many calories a person needs per day based on age, sex, height, weight and activity.

Theory / methods

	•	Collect: heart rate, HRV, resting heart rate and breathing from the Apple Watch, and steps, sleep and weight from iPhone Health. Users can also take the GAD-7 and EDE-Q surveys. A meal log is included too.
	•	Score: we average the survey answers. Watch data is turned into a stress percentage and a percentage for eating warning signs. Each one is placed at Low, Middle or High.
	•	Support: every level comes with its own action, from a reminder, to calming tips and food ideas, to booking a specialist. If answers show risk, the app displays UAE help lines (999, 800-4673).

Experimental setup
We built the mobile app in Flutter and Dart. Firebase manages accounts and stores results for as many as six family profiles. The health package reads data from Apple HealthKit, and the Google Gemini API handles the AI assessment, recipe suggestions and daily needs.

Google Maps and the phone's location find clinics close to the user (UAE only). EmailJS sends out booking confirmations. We first tested the screens in DartPad with a placeholder database, then on an iPhone connected to Apple Health.

Results
The final app works and includes surveys, an AI assessment, stress and eating charts from hourly up to monthly, booking based on severity, food suggestions, family profiles and daily athkar.

Warning levels

Level	Action
Low	A short reminder to keep it up
Middle	Breathing exercises, regular meals, calming recipes
High	Reach out to someone and see the earliest available appointments

Appointment dates use colors: red dates are for High only, orange for Middle and High, and green for all users.

Food support

	•	Recipes from many countries, Emirati dishes included, chosen by weight, height and stress level, with the vitamins and minerals listed for each.
	•	Gemini suggests new recipes and calculates daily calories and nutrients.
	•	Users at high risk of an eating disorder are never shown calories or targets.

Discussion
Limitations. Heart rate and stress tracking only work with an Apple Watch. If the user doesn't have one, the app falls back on iPhone steps and sleep along with the surveys.

We set the rules behind the stress and eating percentages ourselves, and they haven't been clinically tested yet.

The AI features need an internet connection and only work while Gemini is available.

Future work. Try the app with real students, fine-tune the score thresholds and bring in more partner clinics.

Conclusion
nafsi looks at stress and eating habits together in a single app. It can assess someone through a watch, a phone or a quick survey, gives a simple Low, Middle or High warning, and connects each level to suitable help, whether that's a small tip or an appointment with a specialist.

The app only points out warning signs. It does not give a medical diagnosis.
