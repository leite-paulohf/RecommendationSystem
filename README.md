# Restaurant Recommendation System

The purpose of this thesis is to apply the principles and techniques existing in the Data Science discipline to develop a predictive model of recommendation system based on the usage history of customers and their favourite restaurants.
Using the dataset provided by Brazilian startup ChefsClub, content-based and collaborative capabilities to identify customer and restaurant profiles were extracted.
From this, data grouping was implemented through the K-Means method whereby it uses the concept of clusters to expose patterns based on the proximity of the information. 
The Clustered data make possible to know which restaurants best match the customer profile. In order to improve the performance of the algorithm and to increase its accuracy, the recommendations are made by rounds; each round uses a restaurants database the user preferences. 
The cycle ends when the total number of recommendations is no more than 50 or when the elbow method, which is responsible for analyzing data variation, identifies that the data cannot be further divided meaning that the number has a low variation.
The information analyzed in this thesis consists initially in learning unsupervised data and later learning by reinforcement, ie semi- supervised, through external action the user.
To evaluate the performance of the chosen method, qualitative tests were performed, following the Pareto principle. 
Recommendations are evaluated by customers using 2 levels of satisfaction (like and remove) and the learning of the algorithm is derived from the customer’s reaction to the recommendation. 
Whenever a recommendation is evaluated positively, the system redo the recommendation using the new information as a basis. 
The same goes for when a recommendation is removed, meaning that the user did not approve the suggestion,resulting in similar data being ignored or no longer displayed.
