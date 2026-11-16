# nafsi

**Stress & Eating-Habits Monitoring App**
Early warning signs and support using Apple Watch, iPhone Health and AI

**Senior Design Group:** Noorah Alshamsi, Mariam Mohammed Binsuwaif, Hend Abdellatif
**Supervisor:** Ibrahim Abaker Hashem, **Mentor:** Manar Abu Talib
**Examination Committee:** Prof. Ashraf Elnagar, Dr. Huseyin Kusetogullari, Dr. Isam Al Jawarneh
**Affiliation:** College of Computing and Informatics, Department of Computer Science, University of Sharjah

---

## Problem Statement

**Why we built nafsi**

Our junior project looked at anxiety and eating disorders and showed that the two are closely linked. When people are stressed, the way they eat often changes: some skip meals, some overeat, and some start to control food strictly.

Most people only notice these signs late. Students in the UAE also lack one simple tool that checks both problems together and points them to help early.

## Technical Background

- **GAD-7** (Spitzer et al., 2006): a 7-question screening survey for anxiety.
- **EDE-Q** (Fairburn & Beglin, 1994): a questionnaire about eating habits over the last 28 days.
- **Heart rate variability (HRV)** drops under stress, so together with resting heart rate, sleep and breathing rate it can show stress levels (Kim et al., 2018).
- **Apple HealthKit** stores Apple Watch and iPhone data. The app reads it with the user's permission.
- **Large language models** such as Google Gemini can turn answers into a short result in plain language.
- **Mifflin-St Jeor equation**, used to estimate daily calorie needs from age, sex, height, weight and activity.

## Theory / Methods

1. **Collect:** Apple Watch (heart rate, HRV, resting heart rate, breathing), iPhone Health (steps, sleep, weight) or the GAD-7 and EDE-Q surveys, plus a meal log.
2. **Score:** Survey answers are averaged. Watch data becomes a stress percentage and an eating warning-sign percentage. Both map to Low, Middle or High.
3. **Support:** Each level gets its own action: a reminder, calming tips and food ideas, or booking a specialist. Risky answers show UAE help lines (999, 800-4673).

## Setup, Experimental

The mobile app is built with **Flutter** and **Dart**. **Firebase** handles accounts and saves results for up to six family profiles. The **health** package reads Apple HealthKit, and the **Google Gemini API** runs the AI assessment, recipe ideas and daily needs.

**Google Maps** and the phone's location show clinics near the user (UAE only). **EmailJS** sends booking confirmations. We tested screens in DartPad with a stand-in database, then on iPhone with Apple Health.

## Results

A working app with surveys, an AI assessment, hourly to monthly stress and eating charts, booking by severity, food recommendations, family profiles and daily athkar.

**Warning levels**

| Level | Action |
|---|---|
| Low | A small reminder to keep going |
| Middle | Breathing, regular meals, calming recipes |
| High | Talk to someone and get the closest appointment dates |

Dates are color-coded: red for High only, orange for Middle and High, green for everyone.

**Food support**

- Recipes from around the world, including Emirati dishes, matched to weight, height and stress, each with vitamins and minerals.
- Gemini suggests new recipes and works out daily calories and nutrients.
- Users with a high eating-disorder risk never see calories or targets.

## Discussions

**Limits.** Heart rate and stress need an Apple Watch. Without one, the app uses iPhone steps and sleep plus the surveys.

The stress and eating percentages use simple rules we designed. They have not been clinically validated yet.

The AI features need the internet and depend on Gemini being available.

**Next steps.** Test with real students, adjust the score limits, and add more partner clinics.

## Conclusion

nafsi brings stress and eating habits together in one app. It checks people with a watch, a phone or a short survey, gives a clear Low, Middle or High warning level, and links each level to the right kind of help, from a small tip to booking a specialist.

The app shows warning signs only and is not a medical diagnosis.

---

*nafsi · Empowering your journey to harmony and peace*
