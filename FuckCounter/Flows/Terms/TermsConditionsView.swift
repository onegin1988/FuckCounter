//
//  TermsConditionsView.swift
//  FuckCounter
//
//  Created by Alex on 17.04.2024.
//

import SwiftUI

struct TermsConditionsView: View {
    
    enum TermsLinks {
        case youronlinechoices
        case aboutads
        
        var title: String {
            switch self {
            case .youronlinechoices: return "https://www.youronlinechoices.eu/"
            case .aboutads: return "www.aboutads.info/choices"
            }
        }
        
        var link: URL? {
            switch self {
            case .youronlinechoices: return URL(string: "https://www.youronlinechoices.eu/")
            case .aboutads: return URL(string: "https://www.aboutads.info/choices")
            }
        }
    }
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    var body: some View {
        ZStack {
            ScrollView {
                Text(termsText)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 32, trailing: 16))
            }
        }
        .padding(.top, safeAreaInsets.top + 64)
        .toolbarBackground(.hidden, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(NavBarModifiers(title: "Terms of Conditions"))
        .modifier(GradientModifiers(style: .red, useBlackOpacity: true))
        .ignoresSafeArea()
    }
    
    private var termsText: AttributedString {
        let text = "This Privacy Policy explains how Swear Counter, Inc. (\"SwearCounter\", \"we\" or \"us\") collects, uses, and discloses information about you when you access or use our websites, mobile application, and other online products and services (collectively, the \"Services\"), and when you contact our customer service team, engage with us on social media, or otherwise interact with us. This policy does not apply to subscription eligibility information we receive from and process on behalf of our enterprise business customers and partners (defined as \"Customer Data\" in the applicable agreement), but this Privacy Policy does apply to your use of the Services, regardless of your subscription or account type.\n\nWe may change this Privacy Policy from time to time. If we make changes, we will notify you by revising the date at the top of the policy and, in some cases, we may provide you with additional notice (such as adding a statement to our website homepage or sending you a notification). We encourage you to review the Privacy Policy whenever you access the Services or otherwise interact with us to stay informed about our information practices and the choices available to you.\nCollection of Information\nInformation You Provide to Us\nWe collect information when you register for an account, participate in interactive features (like by submitting a meditation rating or completing a check-in), fill out a form or a survey, participate in a contest or promotion, make a purchase, communicate with us via social media sites, request customer support, or otherwise communicate with us. The information you may provide includes your name, email, password, street address, payment method information, goals, previous meditation experience, moods and reflections you provide during check-ins, feedback and survey responses, and other information about you included within your messages to us or otherwise provided via the Services. Some users also provide health-related information in connection with providing feedback or other messages to us, and we process that information consistent with the purpose for which it was provided.\nOther Information About Your Use of the Services\nWhen you use our Services, we collect the following information about you:\n • Usage Information: Whenever you use our Services, we collect usage information, such as the sessions you use, videos you view or content you listen to, what screens or features you access, and other similar types of usage information.\n • Transactional Information: When you make a purchase or return, we collect information about the transaction, such as product description, price, subscription or free trial expiration date, and time and date of the transaction.\n • Log Information: We collect standard log files when you use our Services, which include the type of web browser you use, app version, access times and dates, pages viewed, your IP address, and the page you visited before navigating to our websites.\n • Device Information: We collect information about the computer or mobile device you use to access our Services, including the hardware model, operating system and version, device identifiers set by your device operating system, and mobile network information (like your connection type, carrier and region).\n • Information we Record: On some occasions, we may record phone or video calls with your consent, such as in connection with our coaching program or when you provide us with feedback or market research.\n • Information we Generate: We generate some information about you based on other information we have collected. For example, like most platforms, we use your IP address to derive the approximate location of your device. We also use your first name to make an educated guess about your gender and use information about your activity to help determine the likelihood of you continuing to use our Services in the future (which we hope will be the case!).\nInformation We Collect from Other Sources\nWe also obtain information about you from other sources, including transaction information from third-party app stores you use to install our app or purchase a subscription, and name and contact information from third-party calendar services. Additionally, if you create or log into your account through a social media service account, we will have access to certain information from that account, such as your name and other account information, in accordance with the authorization procedures set by that social media service. Finally, we may obtain information about you from publicly available sources, marketing and advertising partners, consumer research platforms, and/or business contact databases.\nUse of Information\nWe use the information we collect to:\n • Provide, maintain and improve our Services, including debugging to identify and repair errors, and developing new products and services;\n • Process transactions and fulfill orders;\n • Send you transactional or relationship messages, such as receipts, account notifications, customer service responses, and other administrative messages;\n • Communicate with you about products, services, and events offered by SwearCounter and others, request feedback, and send news, gifts or other information we think will be of interest to you (see the \"Your Choices\" section below for information on how to opt out of marketing messages);\n • Monitor and analyze trends, usage, and activities in connection with our Services;\n • Comply with the law, such as by processing transactional records for tax filings and other compliance activities;\n • Personalize your online experience and the advertisements you see on other platforms based on your preferences, interests, and browsing behavior; and\n • Facilitate contests, sweepstakes, and promotions and process and deliver entries and rewards.\nSharing of Information\nWe share information about you as follows and as otherwise described in this Privacy Policy or at the time of collection:\n • With companies and contractors that perform services for us, including email service providers, payment processors, fraud prevention vendors and other service providers;\n • In response to a request for information if we believe disclosure is in accordance with, or required by, any applicable law or legal process, including court order, subpoena, or other lawful requests by public authorities to meet national security or law enforcement requirements;\n • If we believe your actions are inconsistent with our user agreements or policies, if we believe you have violated the law, or to protect the rights, property, and safety of SwearCounter or others;\n • In connection with, or during negotiations of, any merger, sale of company assets, financing or acquisition of all or a portion of our business by another company;\n • Between and among SwearCounter and our current and future parents, affiliates, subsidiaries, and other companies under common control and ownership; and\n • With your consent or at your direction. For instance, you may choose to share actions you take on our Services with third-party social media services via the integrated tools we provide via our Services.\nWe also share aggregated or other information not subject to obligations under the data protection laws of your jurisdiction with third parties. For example, we sometimes share aggregate information with research organizations to help facilitate their research.\nAdvertising and Analytics Services Provided by Others\nWe allow others to provide analytics services and serve advertisements on our behalf across the web and in mobile applications. These entities use cookies, web beacons, device identifiers and other technologies to collect information about your use of the Services and other websites and online services, including your IP address, device identifiers, web browser, mobile network information, pages viewed, time spent on pages or in apps, links clicked, and conversion information. This information may be used by Calm and others to, among other things, analyze and track data, determine the popularity of certain content, deliver advertising and content targeted to your interests on our Services and other websites and online services, and better understand your online activity. You can disable cookies used for advertising purposes through our cookie preferences manager. Or, for more information about interest-based ads, including to use ad industry tools to opt out of having your web browsing information used for behavioral advertising purposes, please visit \(TermsLinks.aboutads.title) (if you are in the EU, please visit \(TermsLinks.youronlinechoices.title)). Your mobile device should also include a feature that allows you to opt out of having certain information collected through apps used SwearCounter strives to make this privacy policy accessible in line with the World Wide Web Consortium's Web Content Accessibility Guidelines, version 2.1.\nContact Us\nIf you have any questions about this Privacy Policy, please contact us at: admin@swearcounter.com"
        
        var attriString = AttributedString(text)
        attriString.foregroundColor = .white
        attriString.font = .custom("Gilroy-Medium", size: 17)
        
        if let youronlinechoicesRange = attriString.range(of: TermsLinks.youronlinechoices.title) {
            attriString[youronlinechoicesRange].link = TermsLinks.youronlinechoices.link
            attriString[youronlinechoicesRange].underlineStyle = .single
        }
        
        if let aboutadsRange = attriString.range(of: TermsLinks.aboutads.title) {
            attriString[aboutadsRange].link = TermsLinks.aboutads.link
            attriString[aboutadsRange].underlineStyle = .single
        }
        
        return attriString
    }
}

#Preview {
    TermsConditionsView()
}
